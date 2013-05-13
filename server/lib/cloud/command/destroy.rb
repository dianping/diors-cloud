module Cloud

  module Command

    class Destroy < Base

      def initialize(project, options = {force: true})
        super(project, options)
      end

      def execute
        require_args(:project)
        with_vm { |vm|vm.action(:destroy, :force_confirm_destroy => options[:force]) and true }
      end

      register(:execute) { project.clear }
    end
  end
end
