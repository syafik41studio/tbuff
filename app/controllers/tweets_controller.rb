class TweetsController < ActionController
  
  before_filter :authenticate_user!
  respond_to :html, :js
  
  def index
    @tweets = current_user.tweets.all
    respond_with(@tweets)
  end
  
  def new
    @tweet = current_user.tweet.new
    respond_with(@tweet)
  end
  
  def create
    @tweet = current_user.tweet.create(params[:tweet])
    respond_with(@tweet)
  end
  
  def edit
    @tweet = Tweet.find(:conditions => {:user_id => current_user.id, :id => params[:id]})
    respond_with(@tweet)
  end
  
  def update
    @tweet = Tweet.find(:conditions => {:user_id => current_user.id, :id => params[:id]})
    @tweet.update_attributes(params[:tweet])
    respond_with(@tweet)
  end
  
  def destroy
    @tweet = Tweet.find(:conditions => {:user_id => current_user.id, :id => params[:id]})
    @tweet.destroy
    respond_with(@tweet)
  end
  
end