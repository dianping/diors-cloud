module DiorsCloud
  # hubot API
  class Hubot < Grape::API

    namespace 'hubot' do 
      
        get "/test" do 
          { status: "test "}
        end

    end 
  end
end         

        
