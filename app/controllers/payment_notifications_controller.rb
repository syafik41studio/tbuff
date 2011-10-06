class PaymentNotificationsController < ApplicationController

  protect_from_forgery :except => [:create]

  def create
    PaymentNotification.create!(:params => params, :cart_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:txn_id])
    cart = Cart.find(params[:invoice])
    plan_id = cart.line_items.first.plan_id
    subcription = Subcription.active_subscription.first
    if subcription.blank?
      Subcription.create(:plan_id => plan_id, :user_id => cart.user_id, :expire => Date.today + 30.days, :active => true)
    else
      if subcription.plan.name.eql?("Free")
        subcription.update_attribute(:active => false)
        Subcription.create(:plan_id => plan_id, :user_id => cart.user_id, :expire => Date.today + 30.days, :active => true)
      else
        Subcription.create(:plan_id => plan_id, :user_id => cart.user_id, :expire => subcription.expire + 30.days)
      end
    end
    render :nothing => true
  end

end