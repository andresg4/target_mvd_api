module Helpers
  def json
    JSON.parse(response.body)
  end

  def sign_up
    post user_registration_path, params: params, as: :json
    new_user = User.find_by_email(params[:email])
    new_user.confirm
  end

  def headers_aux(user)
    user.create_new_auth_token
  end
end
