every 1.minute do
  runner "BufferPreference.post_tweet", :environment => :development
end

every 10.minutes do
  runner "TwitterUsersController.send_notification"
end
