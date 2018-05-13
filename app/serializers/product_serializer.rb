class ProductSerializer < ActiveModel::Serializer
  belongs_to :category
  attributes :id, :name, :price
end
