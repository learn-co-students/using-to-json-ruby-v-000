class PostSerializer
  def self.serialize(post)

    # start with the open brace to create a valid JSON object
    serialized_post = '{'

    serialized_product += '"id": ' + product.id.to_s + ', '
  	serialized_product += '"price": ' + product.price.to_s + ', '
  	serialized_product += '"inventory": ' + product.inventory.to_s + ', '
  	serialized_product += '"name": "' + product.name + '", '
  	serialized_product += '"description": "' + product.description + '" '

    # and end with the close brace
    serialized_post += '}'
  end
end
