module Cloud

  module Command
    class Init < Base

      attr_reader :box
      def initialize(project, box = Settings.diors.box.default)
        super(project)
        @box = Settings.diors.box.list.include?(box) ? box : Settings.diors.box.default
      end

      def execute
        begin
          contents = Vagrant::Util::TemplateRenderer.render(template_path, init_params)
          Machine.create(ip: init_params[:ip], project_id: project.id)
          vagrantfile.open("w+") do |f|
            f.write(contents)
          end
        rescue NoIpAvailableError
          return -1
        end
        true
      end

      def template_path
        Rails.root.join("lib/templates/Vagrantfile")
      end

      def init_params
        @init_params ||= Settings.diors.network.to_hash.merge(box_name: box, app_name: project.slug, ip: IpPool.assign.ip)
      end
    end
  end
end
