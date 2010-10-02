class OrderMailer < ActionMailer::Base
  def order_confirmation(order)
    @recipients = order.email
    @subject = "Bestilling fra Ølstykke Dyreklinik"
    @sent_on = Time.now
    @body = { :order => order, :token => order.token }
  end

  def shipment_confirmation(order)
    @recipients = order.email
    @subject = "Din ordre fra Ølstykke Dyreklinik er sendt (" + order.price.to_s + "kr.)"
    @sent_on = Time.now
    @body = { :order => order }
  end
end
