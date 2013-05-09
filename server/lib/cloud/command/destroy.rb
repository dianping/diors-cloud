module Cloud

  module Command

    class Destroy < Base

      def initialize(project, options = {force: true})
        super(project, options)
      end

      def execute
        with_target_vms([], :reverse => true) do |vm|
          vm.action(:destroy, :force_confirm_destroy => options[:force])
        end
        true
      end

      register(:execute) { machine.to_unassign }
    end
  end
end
