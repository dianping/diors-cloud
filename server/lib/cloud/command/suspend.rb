module Cloud

  module Command

    class Suspend < Base

      def initialize(project)
        super(project)
      end

      def execute
        with_vm(:running, :saved) { |vm| vm.action(:suspend) and true }
      end

      register(:execute) { machine.to_suspend }
    end
  end
end
