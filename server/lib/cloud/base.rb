module Cloud
  class Base
    attr_reader :project
    def initialize(project)
      @project = project 
    end

    def env
      @env ||= Vagrant::Environment.new({:ui_class => Vagrant::UI::Colored, :cwd => project.path})
    end

  end
end
