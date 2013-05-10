require 'digest/md5'

module Cloud

  module Command

    class ResetPassword < Base

      attr_reader :user, :password
      def initialize(project, user, password)
        super(project)
        @user = user
        @password = password
      end

      def execute
        require_args(:project, :user, :password)
        with_vm(:running) do
          errors.add("Reset password to `#{project.name}` failed.") and return false unless machine.reset_password(password)
          true
        end
      end

    end
  end
end
