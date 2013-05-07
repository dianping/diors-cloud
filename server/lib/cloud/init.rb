module Cloud
  class Init < Base

    attr_reader :box
    def initialize(project, box = Settings.diors.box.default)
      super(project)
      @box = Settings.diors.box.list.include?(box) ? box : Settings.diors.box.default
    end

    def execute
      contents = Vagrant::Util::TemplateRenderer.render(template_path, init_params)
      vagrantfile.open("w+") do |f|
        f.write(contents)
      end
    end

    def template_path
      Rails.root.join("lib/templates/Vagrantfile")
    end

    def init_params
      Settings.diors.network.merge(box_name: box, app_name: project.slug)
    end
  end
end
