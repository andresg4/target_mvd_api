module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # request_params = request.params
      access_token, client_id, uid = request.params.values_at(:'access-token', :client, :uid)
      # access_token = request_params[:'access-token']
      # client_id = request_params[:client]
      # uid = request_params[:uid]
      user = User.find_by_uid(uid)

      if user&.valid_token?(access_token, client_id)
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
