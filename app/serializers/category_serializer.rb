class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :products_count

  def products_count
    object.products.count
  end
end
