if @saved
  json.email @user.email
else
  json.error @user.errors
end
