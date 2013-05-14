class App < Grape::API

  before { authenticate! }

  namespace 'app' do 

    get ":app_name/init" do 
      project = Project.create_with_owner(params[:app_name], current_user)
      render_business_error!(project.errors.full_messages) and return if project.errors.present?
      CloudCommandWorker.perform_async(:init, project.id, current_user.id)
      waiting!
    end

    get ":app_name/destroy" do 
      auth_project_owner!
      CloudCommandWorker.perform_async(:destroy, current_project.id, current_user.id)
      waiting!
    end

    #http://localhost:3000/api/v1/app/roger1/user/add?user_account=ttt@dianping.com&hubot_token=123456&email=roger.chen@dianping.com
    get ":app_name/user/add" do 
      auth_project_owner!
      user = User.where(email: params[:user_account]).first || create_user(params[:user_account])
      if current_project.has_member? user
        { status: 503, message: "`#{params[:user_account]}` has been granted permission." }
      else
        current_project.users << user
        { status: 200, message: "Grant access privilege of `#{current_project.name}` to `#{params[:user_account]}`.\nTell `#{params[:user_account]}` to bind ssh key to `#{current_project.name}`." }
      end
    end

    get ":app_name/user/delete" do 
      auth_project_owner!
      forbidden!('You can not delete yourself.') if current_project.owner == user
      CloudCommandWorker.perform_async(:unbind_key, current_project.id, current_user.id, params[:user_account])
      waiting!
    end

    get ":app_name/user/list" do 
      auth_project_user!
      users = current_project.users.map{|u| { email: u.email, role: ((current_project.owner == u) ? 'owner' : 'member') } }
      { status: 200, users: users } 
    end

    #app vm action
    get ":app_name/inst/up" do 
      auth_project_user!
      CloudCommandWorker.perform_async(:up, current_project.id, current_user.id)
      waiting! 30
    end

    get ":app_name/inst/halt" do 
      auth_project_user!
      CloudCommandWorker.perform_async(:halt, current_project.id, current_user.id)
      waiting!
    end

    get ":app_name/inst/suspend" do 
      auth_project_user!
      CloudCommandWorker.perform_async(:suspend, current_project.id, current_user.id)
      waiting!
    end

    get ":app_name/inst/resume" do 
      auth_project_user!
      CloudCommandWorker.perform_async(:resume, current_project.id, current_user.id)
      waiting!
    end

    get ":app_name/inst/state" do 
      auth_project_user!
      CloudCommandWorker.perform_async(:state, current_project.id, current_user.id)
      waiting!
    end

    #app auth action
    get ":app_name/ssh/bindkey" do 
      auth_project_user!
      CloudCommandWorker.perform_async(:bind_key, current_project.id, current_user.id, params[:key_string])
      waiting!
    end

    get ":app_name/ssh/passwd" do 
      auth_project_user!
      CloudCommandWorker.perform_async(:reset_password, current_project.id, current_user.id, params[:password])
      waiting!
    end

  end 
end
