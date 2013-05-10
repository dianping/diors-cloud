module DiorsCloud
  # App API
  class App < Grape::API

    namespace 'app' do 
        
        #test
        get "/test" do 
          { status: "test " }
        end

        #app init,destroy,list
        get ":app_name/init" do 
          { status: "init" }
        end

        get ":app_name/destroy" do 
          { status: "destroy" }
        end

        #http://localhost:3000/api/v1/app/list?hubot_token=123456&email=roger.chen@dianping.com
        #http://localhost:3000/api/v1/app/list?token=8b242e951d4fb822
        get "list" do 
          { status: 200, app: current_user.projects.map{|p| { name: p.name, owner: p.owner.name }} }
        end

        #app user action
        get ":app_name/user/delete/:user_account" do 
          { status: "usr_delete" }
        end

        get ":app_name/user/list" do 
          auth_project_user!
          users = current_project.users.map{|u| { name: u.email, role: ((current_project.owner == u) ? 'owner' : 'member') } }
          { status: 200, users: users } 
        end

        #app vm action
        get ":app_name/inst/up" do 
          { status: "usr_up" }
        end

        get ":app_name/inst/halt" do 
          { status: "halt " }
        end

        get ":app_name/inst/suspend" do 
          { status: "suspend" }
        end

        #app auth action
        get ":app_name/ssh/bindkey/:key_string" do 
          { status: "halt " }
        end

        get ":app_name/ssh/passwd/:password" do 
          { status: "password" }
        end

    end 
  end
end         

        
