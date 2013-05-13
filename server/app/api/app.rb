class App < Grape::API

  before { authenticate! }

  namespace 'app' do 

    #app init,destroy,list
    get ":app_name/init" do 
      project = Project.create_with_owner(params[:app_name], current_user)
      render_business_error!(project.errors.full_messages) and return if project.errors.present?
      cmd = Cloud::Command::Init.new(project)
      cmd.execute ? success! : render_business_error!(cmd.errors)
    end

    get ":app_name/destroy" do 
      auth_project_owner!
      cmd = Cloud::Command::Destroy.new(current_project)
      cmd.execute ? success! : render_business_error!(cmd.errors)
    end

    #http://localhost:3000/api/v1/app/list?hubot_token=123456&email=roger.chen@dianping.com
    #http://localhost:3000/api/v1/app/list?token=8b242e951d4fb822
    get "list" do 
      { status: 200, app: current_user.projects.map{|p| { name: p.name, 
                                                          owner: p.owner.name,
                                                          ip: p.try(:machine).try(:ip),
                                                          status: Machine::STATUS.invert[p.try(:machine).try(:status)]  }} }
    end

    #app user action
    #http://localhost:3000/api/v1/app/roger1/user/add?user_account=ttt@dianping.com&hubot_token=123456&email=roger.chen@dianping.com
    get ":app_name/user/add" do 
      auth_project_owner!
      user = User.where(email: params[:user_account]).first
      user = create_user(params[:user_account]) unless user
      if current_project.has_member? user 
        { status: 503, message: 'add user existed' }
      else  
        current_project.users << user
        { status: 200 }
      end  
    end

    get ":app_name/user/delete" do 
      auth_project_owner!
      user = User.where(email: params[:user_account]).first
      not_found!('user') unless user
      forbidden!('delete owner') if current_project.owner == user
      current_project.users.delete(user)
      { status: 200 }
    end

    get ":app_name/user/list" do 
      auth_project_user!
      users = current_project.users.map{|u| { name: u.email, role: ((current_project.owner == u) ? 'owner' : 'member') } }
      { status: 200, users: users } 
    end

    #app vm action
    get ":app_name/inst/up" do 
      auth_project_user!
      cmd = Cloud::Command::Up.new(current_project)
      cmd.execute ? success! : render_business_error!(cmd.errors)
    end

    get ":app_name/inst/halt" do 
      auth_project_user!
      cmd = Cloud::Command::Halt.new(current_project)
      cmd.execute ? success! : render_business_error!(cmd.errors)
    end

    get ":app_name/inst/suspend" do 
      auth_project_user!
      cmd = Cloud::Command::Suspend.new(current_project)
      cmd.execute ? success! : render_business_error!(cmd.errors)
    end

    get ":app_name/inst/resume" do 
      auth_project_user!
      cmd = Cloud::Command::Resume.new(current_project)
      cmd.execute ? success! : render_business_error!(cmd.errors)
    end

    #app auth action
    get ":app_name/ssh/bindkey" do 
      auth_project_user!
      cmd = Cloud::Command::BindKey.new(current_project, current_user, params[:key_string])
      cmd.execute ? success! : render_business_error!(cmd.errors)
    end

    get ":app_name/ssh/passwd/:password" do 
      auth_project_user!
      cmd = Cloud::Command::ResetPassword.new(current_project, current_user, params[:key_string])
      cmd.execute ? success! : render_business_error!(cmd.errors)
    end

  end 
end
