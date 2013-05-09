module Cloud

  module Command

    class Up < Base

      def initialize(project)
        super(project)
      end

      def execute
        env.batch(true) do |batch|
          with_target_vms([]) do |vm|
            batch.action(vm, :up)
          end
        end
        true
      end

      register(:execute) { machine.to_up }

    end
  end
end
