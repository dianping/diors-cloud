require 'digest/md5'

module Cloud

  module Command

    class BindKey < Base

      attr_reader :pub_key
      def initialize(project_id, user_id_or_email, pub_key)
        super(project_id, user_id_or_email)
        @pub_key = pub_key
      end

      def execute
        require_args(:project, :user, :pub_key)
        with_vm(:running) do
          key = user.keys.find_by_identifier(Digest::MD5.hexdigest(self.pub_key))
          errors.add("Bind key to `#{project.name}` failed.") and return false if key.blank? && (key = user.add_key(pub_key)).blank?
          # This key should be added to user's key list.
          errors.add("This key has been already binded to `#{project.name}`.") and return false if key.machines.exists?(machine.id)
          errors.add("Bind key to `#{project.name}` failed.") and return false unless machine.bind_key(key)
          true
        end
      end

      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "The key has been binded.")
      end
    end
  end
end
