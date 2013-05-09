module Cloud

  module Command

    class BindKey < Base

      attr_reader :key, :user
      def initialize(project, key, user)
        super(project)
        @key = key
        @user = user
      end

      def execute
        with_vm(:running) { user.bind_key(key, machine) }
      end

    end
  end
end
