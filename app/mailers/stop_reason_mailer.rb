class StopReasonMailer < ApplicationMailer
default from: 'notifications@example.com'
 
  def perform(user, operator_id, parent_id, parent_type, stop_reason)
    @user = user
    @operator = Operator.find(operator_id)
    if(parent_type=="Movement")
    	@movement = Movement.find(parent_id)
    end
    @stop_reason = stop_reason
    mail(to: @user.email, subject: 'ERO Stop Reason Notification')
  end
end