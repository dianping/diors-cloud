class API < Grape::API
  version 'v1', using: :path
  format :json

  rescue_from ActiveRecord::RecordNotFound do
    rack_response({'message' => '404 Not found', 'status' => 404 }.to_json, 404)
  end

  rescue_from :all do |exception|
    # lifted from https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/middleware/debug_exceptions.rb#L60
    # why is this not wrapped in something reusable?
    trace = exception.backtrace

    message = "\n#{exception.class} (#{exception.message}):\n"
    message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
    message << "  " << trace.join("\n  ")

    rack_response({'message' => '500 Internal Server Error', 'status' => 500 }, 500)
  end

  get "/ping" do 
    "pong"
  end

  helpers APIHelpers

  mount App
end
