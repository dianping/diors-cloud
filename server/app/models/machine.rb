class Machine < ActiveRecord::Base
  attr_accessible :ip, :status, :uuid, :project_id
  
  belongs_to :project
  validates_presence_of :ip, :project_id

  STATUS = { unassign: -1, halt: 0, up: 1, suspend: 2 }

  def to_unassign
    update_attributes(status: STATUS[:unassign], uuid: nil) unless vm_exists?
  end

  def to_up
    update_attributes(uuid: vm.id, status: STATUS[:up]) if vm_status_match?(:running)
  end

  def to_halt
    update_attribute(:status, STATUS[:halt]) if vm_status_match?(:poweroff)
  end

  def to_suspend
    update_attribute(:status, STATUS[:suspend]) if vm_status_match?(:saved)
  end

  def vm_exists?
    return false if uuid.blank?
    begin
      VagrantPlugins::ProviderVirtualBox::Driver::Meta.new(uuid)
      true
    rescue VagrantPlugins::ProviderVirtualBox::Driver::Meta::VMNotFound
      false
    end
  end

  def env
    @env ||= Vagrant::Environment.new({:ui_class => Vagrant::UI::Silent, :cwd => project.path})
  end

  def vm
    @vm ||= begin
      return nil if env.active_machines.blank?
      env.active_machines.each do |(name, provider)|
        # We have only one machine per Vagrantfile now.
        return env.machine(name, provider)
      end
    end
  end

  def vm!
    @vm = nil and vm
  end

  def vm_status_match?(status)
    vm && vm.state.id == status
  end

  def vm_status
    case state = vm.try(:state).try(:id)
    when nil then :uncreated
    when :saved then :suspended
    else state
    end
  end
end
