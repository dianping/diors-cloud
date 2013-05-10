module Cloud

  module Command

    class Halt < Base

      def initialize(project, options = {force: false})
        super(project, options)
      end

      def execute
        require_args(:project)
        with_vm(:running, :saved, :poweroff) { |vm| vm.action(:halt, :force_halt => options[:force]) and true }
      end

      register(:execute, skip_hook_when: false) { machine.to_halt }
    end
  end
end
