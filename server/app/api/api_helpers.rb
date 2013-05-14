module APIHelpers
  def current_user
    @current_user ||= get_current_user
  end

  def current_project
    @current_project ||= Project.find_by_name(params[:app_name])
  end  

  def auth_project_user!
    not_found!('App') unless current_project
    forbidden!('Project') unless current_project.has_member? current_user
  end  

  def auth_project_owner!
    not_found!('App') unless current_project
    forbidden!('You are not the owner of this app.') unless current_project.owner == current_user
  end

  def authenticate!
    unauthorized! unless params[:hubot_token] == Settings.diors.hubot.token
  end

  def forbidden!(resource = nil)
    message = ["403"]
    message << resource if resource
    message << "Not Allowed"
    render_api_error!(message.join(' '), 403)
  end

  def bad_request!(attribute)
    message = ["400 (Bad request)"]
    message << "\"" + attribute.to_s + "\" not given"
    render_api_error!(message.join(' '), 400)
  end

  def not_found!(resource = nil)
    message = ["404"]
    message << resource if resource
    message << "Not Found"
    render_api_error!(message.join(' '), 404)
  end

  def waiting!(time = nil)
    message = ["Please waiting"]
    message << "about #{time} seconds" if time
    message << "..."
    { status: 200, message: message.join(' ') }
  end

  def unauthorized!
    render_api_error!('401 Unauthorized', 401)
  end

  def not_allowed!
    render_api_error!('Method Not Allowed', 405)
  end

  def render_api_error!(message, status)
    error!({'message' => message, 'status' => status }, status)
  end

  def render_business_error!(messages)
    error!({'message' => messages.join(' '), 'status' => 405 }, 405)
  end

  private

  def get_current_user
    if params[:token]
      User.find_by_token(params[:token]) || forbidden!
    elsif params[:email]
      User.find_by_email(params[:email]) || create_user(params[:email]) || forbidden!
    else
      forbidden!  
    end  
  end 

  def create_user(email)
    user = User.new(email: email, password: email, password_confirmation: email)
    user.save ? user : nil
  end

end
