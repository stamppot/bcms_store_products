class OrderMailer < ActionMailer::Base
  def shipment_confirmation(order)
    @recipients = order.email
    @subject = "Din ordre fra Ølstykke Dyreklinik er sendt ($" + order.price.to_s + ")"
    @sent_on = Time.now
    @body = { :order => order }
  end
end
