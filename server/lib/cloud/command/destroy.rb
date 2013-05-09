module Cloud

  module Command

    class Destroy < Base

      def initialize(project, options = {force: true})
        super(project, options)
      end

      def execute
        with_vm { |vm|vm.action(:destroy, :force_confirm_destroy => options[:force]) and true }
      end

      register(:execute) { machine.to_unassign }
    end
  end
end
