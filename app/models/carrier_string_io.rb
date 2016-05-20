class CarrierStringIO < StringIO
  def original_filename
    "product.png"
  end

  def content_type
    "image/jpeg"
  end
end
