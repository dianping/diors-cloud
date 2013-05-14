require 'ipaddr'

module Cloud

  module Command
    class Init < Base

      attr_reader :box
      def initialize(project_id, user_id_or_email, box = Settings.diors.box.default)
        super(project_id, user_id_or_email, {machine_required: false})
        @box = Settings.diors.box.list.include?(box) ? box : Settings.diors.box.default
      end

      def execute
        require_args(:project, :user)
        begin
          if project.machine.present?
            errors.add("This project has been initialized.")
            return false
          else
            Machine.create(ip: init_params[:ip], project_id: project.id)
            create_vagrantfile
          end
        rescue NoIpAvailableError
          return false
        end
        true
      end

      register(:execute) do
        Cloud::Notify::Hubot.send(user.email, errors | "App `#{project.name}` has been initialized.\n Ip is #{init_params[:ip]}.\n Now you can type `diors app #{project.name} up` to start machine.")
      end

      def template_path
        Rails.root.join("lib/templates/Vagrantfile")
      end

      private
      def create_vagrantfile
        contents = Vagrant::Util::TemplateRenderer.render(template_path, init_params)
        vagrantfile.open("w+") do |f|
          f.write(contents)
        end
      end

      def init_params
        @init_params ||= Settings.diors.vm.to_hash.merge(box_name: box, app_name: project.slug).merge(network_params(IpPool.assign.ip))
      end

      def network_params(ip)
        {ip: ip, mask: "255.255.255.0", gateway: ip.sub(/\d+$/, '1')}
      end
    end
  end
end
