# Load the rails application
require File.expand_path('../application', __FILE__)

require File.expand_path('../../lib/twitter_auth', __FILE__)

# Initialize the rails application
Tweetbuffer::Application.initialize!
