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

        get "list" do 
          { status: 200, app:current_user.projects.map{|p| { name: p.name, owner: p.owner.name }} }
        end

        #app user action
        get ":app_name/user/delete/:user_account" do 
          { status: "usr_delete" }
        end

        get ":app_name/user/list" do 
          project = Project.find_by_name(params[:app_name])
          if project
            users = project.users.map{|u| { name: u.email, role: ((project.owner == u) ? 'owner' : 'member') } }
            { 
              status: 200, 
              users: users
            } 
          else  
            { status: 500, message: "app not found" }
          end  
        end

        #app vm action
        get ":app_name/up" do 
          { status: "usr_up" }
        end

        get ":app_name/halt" do 
          { status: "halt " }
        end

        get ":app_name/suspend" do 
          { status: "suspend" }
        end

        #app auth action
        get ":app_name/bindkey/:key_string" do 
          { status: "halt " }
        end

        get ":app_name/passwd/:password" do 
          { status: "password" }
        end

    end 
  end
end         

        
