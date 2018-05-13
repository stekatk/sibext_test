require "rails_helper"

RSpec.describe ProductsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/categories/1/products").to route_to("products#index", :category_id => "1")
    end

    it "routes to #create" do
      expect(:post => "/categories/1/products").to route_to("products#create", :category_id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/products/1").to route_to("products#destroy", :id => "1")
    end

  end
end
