class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def trustauth
    if auth_hash['info']['result']
      user = User.find_or_create_by_public_key(auth_hash['info']['public_key'])

      if not user_signed_in?
        sign_in_and_redirect(:user, user) and return
      end
    end
    redirect_to root_path
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
