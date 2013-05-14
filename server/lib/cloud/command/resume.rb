module Cloud

  module Command

    class Resume < Base

      def execute
        require_args(:project, :user)
        with_vm(:saved) { |vm| vm.action(:resume) and true }
      end

      register(:execute, skip_hook_when: false) { machine.to_up }
      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "Machine of `#{project.name}` has stated.")
      end
    end
  end
end
