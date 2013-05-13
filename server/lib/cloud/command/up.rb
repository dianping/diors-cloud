module Cloud

  module Command

    class Up < Base

      def initialize(project)
        super(project)
      end

      def execute
        require_args(:project)
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

    end
  end
end
