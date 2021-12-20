class User < ApplicationRecord
  # Railscast and https://guides.rubyonrails.org/active_model_basics.html#securepassword
  include ActiveModel::SecurePassword
  has_secure_password
  # attr_accessor :email, :username, :password_digest # comment said remove this and change to modern Rails which I did and it worked
end
