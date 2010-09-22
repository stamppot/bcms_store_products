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
    pr = "%05.2f" % ((price * 100).round / 100.0).gsub(".", ",")
    pr << "0" if pr[-3,1] = ","
  end
  
  def product_photo(product)
    default_photo = "/themes/dyrgod/images/logo_no_text_small.png"
		if product.product_photos.any?
			if product.product_photos.first.attachment
				default_photo = product.product_photos.first.attachment.file_path
			else
				default_photo = product.product_photos.second.attachment.file_path if product.product_photos.second.attachment
			end
		end
  end
end
