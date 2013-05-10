module Cloud

  class NoIpAvailableError < StandardError; end
  class MachineNotAssignedError < StandardError; end
  class MissingArgumentError < StandardError; end

  module Command

    class Base < Vagrant.plugin("2", :command)

      extend Forwardable
      include Hooks::Base

      attr_reader :project, :options, :errors
      def_delegators :machine, :vm

      def initialize(project, options = {})
        options = default_options.merge(options)
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

      def env
        Vagrant::Environment.new({:ui_class => Vagrant::UI::Silent, :cwd => project.path})
      end

      def machine
        @machine ||= project.machine
      end

      def with_vm(*states)
        states = Array(states)
        if machine.blank?
          errors.add("This project has not been assigned a machine.")
          return false
        end
        if vm.present? && (states.blank? ? true : states.include?(vm.state.id))
          yield vm
        else
          errors.add("You can not do this action, the status of this machine is #{machine.vm_status}.")
          false
        end
      end

      private
      def default_options
        {machine_required: true}
      end

      def require_args(*args)
        args.each do |arg|
          raise MissingArgumentError.new(arg) if send(arg).blank?
        end
      end

    end
  end

end
