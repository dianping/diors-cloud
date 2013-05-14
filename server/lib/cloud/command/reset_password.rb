require 'digest/md5'

module Cloud

  module Command

    class ResetPassword < Base

      attr_reader :password
      def initialize(project_id, user_id_or_email, password)
        super(project_id, user_id_or_email)
        @password = password
      end

      def execute
        require_args(:project, :user, :password)
        with_vm(:running) do
          errors.add("Reset password to `#{project.name}` failed.") and return false unless machine.reset_password(password)
          true
        end
      end

      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "The password of `#{project.name}` has been reseted.")
      end
    end
  end
end
