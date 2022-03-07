class ApplicationController < ActionController::API
  include Authorization
  include Pundit::Authorization
end
