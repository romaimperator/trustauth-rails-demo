class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def trustauth
    if auth_hash['info']['result']
      user = User.find_by_public_key(auth_hash['info']['public_key'])

      if not user
        # This user doesn't have an account so save the public key and redirect them to the page to enter an email.
        session[:public_key] = auth_hash['info']['public_key']
        redirect_to new_user_path and return
      else
        if not user_signed_in?
          sign_in_and_redirect(:user, user) and return
        end
      end
    else
      redirect_to root_path, :notice => "Authentication failed."
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
