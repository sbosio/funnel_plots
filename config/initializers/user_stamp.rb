
#
# Initilization file for UserStamp gem
#
UserStamp.configure do |config|
  # ===== Config.current_user =====
  # Set the name of the user object created when checking authentication
  # By default uses the current_user object that devise creates
  # need to make sure that the user_field is defined within the user object
  # Default
  config.current_user = :usuario_actual

  # ===== Config.user_field ======
  # The field within the user object / user database that is stored for each record in the database
  # To change the behavior to store the user.id field use the following config:
  config.user_field = :id
  # To store the user's email use the following config:
  # config.user_field = :email
  # Default
  # config.user_field = :login_name
end
