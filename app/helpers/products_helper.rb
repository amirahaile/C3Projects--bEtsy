module ProductsHelper
  # eg. "10.0 x 15.3 x 2.5"
  def dimensions(product)
    length = product.length_in_cms
    width = product.width_in_cms
    height = product.height_in_cms

    "#{length} cm x #{width} cm x #{height} cm"
  end
end
