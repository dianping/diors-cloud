class Machine < ActiveRecord::Base
  attr_accessible :ip, :status, :uuid, :project_id
  
  belongs_to :project

  STATUS = { unassign: -1, halt: 0, up: 1, suspend: 2 }

  def to_unassign
    update_attributes(status: STATUS[:unassign], uuid: nil) unless vm_exists?
  end

  def to_up
    update_attributes(uuid: vm.id, status: STATUS[:up]) if vm.state.id == :running
  end

  def to_halt
    update_attribute(:status, STATUS[:halt]) if vm.state.id == :poweroff
  end

  def to_suspend
    update_attribute(:status, STATUS[:suspend]) if vm.state.id == :saved
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
    env.active_machines.each do |(name, provider)|
      # We have only one machine per Vagrantfile now.
      return env.machine(name, provider)
    end
  end
end
