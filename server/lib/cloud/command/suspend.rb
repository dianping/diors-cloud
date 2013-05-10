module Cloud

  module Command

    class Suspend < Base

      def initialize(project)
        super(project)
      end

      def execute
        require_args(:project)
        with_vm(:running, :saved) { |vm| vm.action(:suspend) and true }
      end

      register(:execute, skip_hook_when: false) { machine.to_suspend }
    end
  end
end
