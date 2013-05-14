module Cloud

  module Command

    class Up < Base

      def execute
        require_args(:project, :user)
        if vagrantfile.exist?
          env.batch(true) do |batch|
            with_target_vms([]) do |vm|
              batch.action(vm, :up) rescue Vagrant::Errors::VagrantError
            end
          end
          true
        else
          errors.add("You need initialize this project First.") and false
        end
      end

      register(:execute, skip_hook_when: false) { machine.to_up }
      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "Machine of `#{project.name}` has started.")
      end

    end
  end
end
