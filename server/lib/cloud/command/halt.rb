module Cloud

  module Command

    class Halt < Base

      def initialize(project_id, user_id_or_email, options = {force: false})
        super(project_id, user_id_or_email, options)
      end

      def execute
        require_args(:project, :user)
        with_vm(:running, :saved, :poweroff) { |vm| vm.action(:halt, :force_halt => options[:force]) and true }
      end

      register(:execute, skip_hook_when: false) { machine.to_halt }
      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "Machine of `#{project.name}` has been turned off.")
      end
    end
  end
end
