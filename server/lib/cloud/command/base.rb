module Cloud

  class NoIpAvailableError < StandardError; end
  class MachineNotAssignedError < StandardError; end

  module Command

    class Base < Vagrant.plugin("2", :command)

      extend Forwardable
      include Hooks::Base

      attr_reader :project, :options
      def_delegator :machine, :env

      def initialize(project, options = {})
        @project = project 
        @options = options
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

    end
  end

end
