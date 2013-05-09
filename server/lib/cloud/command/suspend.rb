module Cloud

  module Command

    class Suspend < Base

      def initialize(project)
        super(project)
      end

      def execute
        with_target_vms([]) do |vm|
          vm.action(:suspend)
        end
        true
      end

      register(:execute) { machine.to_suspend }
    end
  end
end
