# frozen_string_literal: true

# config/initializers/swagger-docs.rb

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end
end

Swagger::Docs::Config.base_api_controllers = [ApiController, Users::SessionsController, Users::RegistrationsController, Users::PasswordsController]

Swagger::Docs::Config.register_apis(
  "1.0" => {
      # the extension used for the API
      api_extension_type: :json,
      # location where our api doc files will be generated, as of now we will store files under public directory
      api_file_path: "public/apidocs",
      # base path url of our application
      # while using production mode, point it to production url
      base_path: "http://localhost:3000",
      # setting this option true tells swagger to clean all files generated in api_file_path directory before any files are generated
      clean_directory: true,
      controller_base_path: "",
    # As we are using Rails-API, our ApplicationController inherits ActionController::API instead of ActionController::Base
    # Hence, we need to add ActionController::API instead of default ActionController::Base
    # parent_controller needs to be specified if API controllers are inheriting some other controller than ApplicationController
    # :parent_controller => ApplicationController,
  }
  )
