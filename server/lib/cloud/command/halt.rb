module Cloud

  module Command

    class Halt < Base

      def initialize(project, options = {force: false})
        super(project, options)
      end

      def execute
        with_vm(:running, :saved, :poweroff) { |vm| vm.action(:halt, :force_halt => options[:force]) and true }
      end

      register(:execute) { machine.to_halt }
    end
  end
end
