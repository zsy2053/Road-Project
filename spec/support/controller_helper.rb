module Controller
  module AuthHelpers
    def add_jwt_header(request, user)
      token = JsonWebToken.encode({user_id: user.id})
      request.headers.merge!({ 'Authorization': "Bearer #{token}" })
    end
  end
end
