require 'digest/md5'

module Cloud

  module Command

    class UnbindKey < Base

      def initialize(project_id, user_id_or_email, unbind_user_account)
        super(project_id, user_id_or_email)
        @unbind_user_account = unbind_user_account
      end

      def unbind_user
        @unbind_user ||= User.find_by_email(@unbind_user_account)
      end

      def execute
        require_args(:project, :user, :unbind_user)
        with_vm(:running) do
          key = project.machine.keys.find_by_user_id(unbind_user.id)
          if key.blank? || !key.machines.exists?(machine.id)
            errors.add("`#{unbind_user.email}` has not access privilege of `#{project.name}`.") and return false
          end
          unless machine.unbind_key(key)
            errors.add("Revoke access privilege of `#{project.name}` from `#{unbinded_user.email}` failed.") and return false
          end
          true
        end
      end

      register(:execute, skip_hook_when: false) { project.users.delete(unbind_user) }
      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "Revoke access privilege of `#{project.name}` from `#{unbind_user.email}`.")
      end
    end
  end
end
