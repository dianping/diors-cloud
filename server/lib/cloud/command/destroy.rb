module Cloud

  module Command

    class Destroy < Base
      
      include Helpers

      def initialize(project_id, user_id_or_email, options = {force: true})
        super(project_id, user_id_or_email, options)
      end

      def execute
        require_args(:project, :user)
        with_vm { |vm| vm.action(:destroy, :force_confirm_destroy => options[:force]) and true }
      end

      register(:execute) { release_ip(project.machine.ip, project.domain) }
      register(:execute) { project.clear }
      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "Machine of `#{project.name}` has been destroyed.")
      end
    end
  end
end
