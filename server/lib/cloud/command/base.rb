module Cloud

  class NoIpAvailableError < StandardError; end
  class MachineNotAssignedError < StandardError; end

  module Command

    class Base < Vagrant.plugin("2", :command)

      extend Forwardable
      include Hooks::Base

      attr_reader :project, :options, :errors
      def_delegators :machine, :env, :vm

      def initialize(project, options = {})
        @project = project 
        @options = options
        @errors = Errors.new
        super(nil, env)
      end

      def vagrantfile
        project.path.join("Vagrantfile")
      end

      def execute
      end

      def machine
        @machine ||= project.machine
      end

      def with_vm(*states)
        states = Array(states)
        if vm.present? && (states.blank? ? true : states.include?(vm.state.id))
          yield vm
        else
          errors.add("You can not do this action, the status of this machine is #{machine.vm_status}.")
          false
        end
      end

    end
  end

end
