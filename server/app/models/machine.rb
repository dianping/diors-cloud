require 'shellwords'

class Machine < ActiveRecord::Base
  attr_accessible :ip, :status, :uuid, :project_id
  
  belongs_to :project
  has_and_belongs_to_many :keys
  validates_presence_of :ip, :project_id

  STATUS = { unassign: -1, halt: 0, up: 1, suspend: 2 }

  def withdraw
    self.destroy if !vm_exists? && IpPool.withdraw(self.ip)
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
    meta.present? ? true : false
  end

  def env
    @env ||= Vagrant::Environment.new({:ui_class => Vagrant::UI::Silent, :cwd => project.path})
  end

  def vm
    @vm ||= begin
      env.active_machines.each do |(name, provider)|
        # We have only one machine per Vagrantfile now.
        return env.machine(name, provider)
      end
      env.machine_names.each do |name|
        return env.machine(name, env.default_provider)
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

  def meta
    begin
      VagrantPlugins::ProviderVirtualBox::Driver::Meta.new(uuid)
    rescue VagrantPlugins::ProviderVirtualBox::Driver::Meta::VMNotFound
      nil
    end
  end

  def bind_key(key)
    if vm_status_match?(:running) && key && key.pub_key.present?
      vm.communicate.tap do |comm|
        comm.execute("mkdir ~/.ssh", {error_check: false})
        comm.execute("touch ~/.ssh/authorized_keys")
        if !comm.test("grep -Fw '#{key.pub_key}' ~/.ssh/authorized_keys")
          comm.execute("echo '#{key.pub_key}' >> ~/.ssh/authorized_keys")
          self.keys << key
          return true
        end
      end
    end
    false
  end

  def unbind_key(key)
    if vm_status_match?(:running) && key && key.pub_key.present?
      vm.communicate.tap do |comm|
        comm.execute("mkdir ~/.ssh", {error_check: false})
        comm.execute("touch ~/.ssh/authorized_keys")
        s = %Q[sed -i '/#{key.pub_key.gsub(/\//, "\\/")}/d' ~/.ssh/authorized_keys]
        comm.execute(s)
        self.keys.delete(key)
        return true
      end
    end
    false
  end

  def reset_password(password)
    if vm_status_match?(:running) && password.present?
      vm.communicate.tap do |comm|
        comm.execute("openssl passwd -crypt '#{password}'") do |std, output|
          encrypted_password = output.strip
          if encrypted_password.present?
            comm.sudo("usermod --password #{encrypted_password} #{Settings.diors.vm.user}")
            return true
          end
        end
      end
    end
    false
  end
end
