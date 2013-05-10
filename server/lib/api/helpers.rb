module DiorsCloud
  module APIHelpers
    def current_user
      @current_user ||= get_current_user
    end

    def current_project
      @current_project ||= Project.find_by_name(params[:app_name])
    end  

    # def user_project
    #   @project ||= find_project
    #   @project || not_found!
    # end

    # def find_project
    #   project = Project.find_by_id(params[:id]) || Project.find_with_namespace(params[:id])

    #   if project && can?(current_user, :read_project, project)
    #     project
    #   else
    #     nil
    #   end
    # end

    # def paginate(object)
    #   object.page(params[:page]).per(params[:per_page].to_i)
    # end

    def auth_project_user!
      not_found!('app') unless current_project
      forbidden!('project') unless current_project.has_member? current_user
    end  

    def auth_project_owner!
      not_found!('app') unless current_project
      forbidden!('project own') unless current_project.owner == current_user
    end  
    # def authenticate!
    #   unauthorized! unless current_user
    # end

    # def authenticated_as_admin!
    #   forbidden! unless current_user.is_admin?
    # end

    # def authorize! action, subject
    #   unless abilities.allowed?(current_user, action, subject)
    #     forbidden!
    #   end
    # end

    # def can?(object, action, subject)
    #   abilities.allowed?(object, action, subject)
    # end

    # # Checks the occurrences of required attributes, each attribute must be present in the params hash
    # # or a Bad Request error is invoked.
    # #
    # # Parameters:
    # #   keys (required) - A hash consisting of keys that must be present
    # def required_attributes!(keys)
    #   keys.each do |key|
    #     bad_request!(key) unless params[key].present?
    #   end
    # end

    # def attributes_for_keys(keys)
    #   attrs = {}
    #   keys.each do |key|
    #     attrs[key] = params[key] if params[key].present?
    #   end
    #   attrs
    # end

    # # error helpers

    def forbidden!(resource = nil)
      message = ["403"]
      message << resource if resource
      message << "Not Allowed"
      render_api_error!(message.join(' '), 403)
    end

    # def bad_request!(attribute)
    #   message = ["400 (Bad request)"]
    #   message << "\"" + attribute.to_s + "\" not given"
    #   render_api_error!(message.join(' '), 400)
    # end

    def not_found!(resource = nil)
      message = ["404"]
      message << resource if resource
      message << "Not Found"
      render_api_error!(message.join(' '), 404)
    end

    # def unauthorized!
    #   render_api_error!('401 Unauthorized', 401)
    # end

    # def not_allowed!
    #   render_api_error!('Method Not Allowed', 405)
    # end

    def render_api_error!(message, status)
      error!({'message' => message, 'status' => status }, status)
    end

    private

    def get_current_user
      if params[:token]
        User.find_by_token(params[:token]) || forbidden!
      elsif params[:hubot_token] == Settings.diors.hubot.token && params[:email]
        User.find_by_email(params[:email]) || forbidden!
      else
        forbidden!  
      end  
    end 

    # def abilities
    #   @abilities ||= begin
    #                    abilities = Six.new
    #                    abilities << Ability
    #                    abilities
    #                  end
    # end
  end
end
