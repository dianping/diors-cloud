module Cloud

  module Command

    class State < Base

      attr_reader :state

      def execute
        require_args(:project, :user)
        with_vm { |vm| @state = vm.state.id and true }
      end

      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "Machine of `#{project.name}` is #{state}. Ip is #{project.machine.ip}. Domain is #{project.domain}.")
      end
    end
  end
end

