module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      access_token, client_id, uid = request.params.values_at(:'access-token', :client, :uid)
      user = User.find_by_uid(uid)

      return user if user&.valid_token?(access_token, client_id)

      reject_unauthorized_connection
    end
  end
end
