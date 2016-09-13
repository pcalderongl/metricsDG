class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_token()
    client_token = DGI::Identity::get_token('http://sso.apps.10.52.46.151.xip.io', '-rqlnQPikN0W', 'XS0AOo6_Ff-KK0_0VoN_')
  #  user_token = DGI::Identity::get_token('http://sso.apps.10.52.46.151.xip.io', 'app', 'appclientsecret', 'user1', 'passw0rd')
  end

  def get_header()
    client_token = get_token()
    header = { :Content_Type => 'application/json', :Authorization => 'Bearer '+ client_token}
    return header
  end
end
