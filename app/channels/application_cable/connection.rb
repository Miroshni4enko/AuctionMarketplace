# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags "ActionCable", current_user.email
    end


    def find_verified_user # this checks whether a user is authenticated with devise
      uid = headers[:uid]
      access_token = headers["access-token"]
      client_id = headers[:client]
      user = User.find_by_uid(uid)
      if user && user.valid_token?(access_token, client_id)
        user
      else
        reject_unauthorized_connection
      end
    end
    private
      def headers
        request.headers
      end
  end
end
