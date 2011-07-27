class TwitterUser < ActiveRecord::Base
  include ::TwitterAuth::OauthUser

  belongs_to :user
  has_many   :buffer_preferences

  attr_protected :twitter_id, :remember_token, :remember_token_expires_at

  TWITTER_ATTRIBUTES = [
    :name,
    :location,
    :description,
    :profile_image_url,
    :url,
    :protected,
    :profile_background_color,
    :profile_sidebar_fill_color,
    :profile_link_color,
    :profile_sidebar_border_color,
    :profile_text_color,
    :profile_background_image_url,
    :profile_background_tile,
    :friends_count,
    :statuses_count,
    :followers_count,
    :favourites_count,
    :time_zone,
    :utc_offset
  ]

  validates_uniqueness_of :twitter_id, :message => "ID has already been taken."

  def self.new_from_twitter_hash(hash)
    raise ArgumentError, 'Invalid hash: must include screen_name.' unless hash.key?('screen_name')
    raise ArgumentError, 'Invalid hash: must include id.' unless hash.key?('id')

    user = TwitterUser.new
    user.twitter_id = hash['id'].to_s
    user.login = hash['screen_name']

    TWITTER_ATTRIBUTES.each do |att|
      user.send("#{att}=", hash[att.to_s]) if user.respond_to?("#{att}=")
    end

    user
  end

  def assign_twitter_attributes(hash)
    TWITTER_ATTRIBUTES.each do |att|
      send("#{att}=", hash[att.to_s]) if respond_to?("#{att}=")
    end
  end

  def update_twitter_attributes(hash)
    assign_twitter_attributes(hash)
    save
  end

  def twitter
    ::TwitterAuth::Dispatcher::Oauth.new(self)
  end

end
