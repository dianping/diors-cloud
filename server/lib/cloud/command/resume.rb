module Cloud

  module Command

    class Resume < Base

      def initialize(project)
        super(project)
      end

      def execute
        with_vm(:saved) { |vm| vm.action(:resume) and true }
      end

      register(:execute) { machine.to_up }
    end
  end
end
