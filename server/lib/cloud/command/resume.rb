module Cloud

  module Command

    class Resume < Base

      def initialize(project)
        super(project)
      end

      def execute
        require_args(:project)
        with_vm(:saved) { |vm| vm.action(:resume) and true }
      end

      register(:execute, skip_hook_when: false) { machine.to_up }
    end
  end
end
