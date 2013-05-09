module Cloud

  module Command

    class Halt < Base

      def initialize(project, options = {force: false})
        super(project, options)
      end

      def execute
        with_target_vms([]) do |vm|
          vm.action(:halt, :force_halt => options[:force])
        end
        true
      end

      register(:execute) { machine.to_halt }
    end
  end
end
