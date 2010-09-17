# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def normal_or_reduced_price(product)
    a_price = product.offer_price > 0 && product.offer_price || product.selling_price
    price_text = danish_price(a_price)
    price_text << "0" if price_text[-2,1] == ","
    if product.offer_price > 0
      product_price = "<span class='price'>#{price_text}</span>"
    else
		  product_price = "<span class='price offer'>#{price_text}</span>"
	  end
  end
  
  def danish_price(price)
    price.to_s.gsub(".", ",")
  end
end
