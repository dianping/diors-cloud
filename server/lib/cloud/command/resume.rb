module Cloud

  module Command

    class Resume < Base

      def initialize(project)
        super(project)
      end

      def execute
        with_target_vms([]) do |vm|
          vm.action(:resume) if vm.state.id == :saved
        end
        true
      end

      register(:execute) { machine.to_up }
    end
  end
end
