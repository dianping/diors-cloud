module Cloud

  module Command

    class State < Base

      attr_reader :state

      def execute
        require_args(:project, :user)
        with_vm { |vm| @state = vm.state.id and true }
      end

      register(:execute, skip_hook_when: false) { machine.to_suspend }
      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "Machine of `#{project.name}` is #{state}.")
      end
    end
  end
end

