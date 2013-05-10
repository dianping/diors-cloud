module Cloud

  module Command
    class Init < Base

      attr_reader :box
      def initialize(project, box = Settings.diors.box.default)
        super(project, {machine_required: false})
        @box = Settings.diors.box.list.include?(box) ? box : Settings.diors.box.default
      end

      def execute
        require_args(:project)
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
        @init_params ||= Settings.diors.vm.to_hash.merge(box_name: box, app_name: project.slug, ip: IpPool.assign.ip)
      end
    end
  end
end
