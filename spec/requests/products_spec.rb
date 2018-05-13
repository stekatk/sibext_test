require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:parsed_response) { JSON.parse response.body }
  let(:first_product) { build :product }
  let(:second_product) { build :product, name: 'Salt'}
  let!(:category) { create :category, products: [first_product, second_product] }

  describe "GET /categories/:category_id/products" do
    let(:expected_json) do
      [
        {
          'id' => 1,
          'name' => 'Bread',
          'price' => 1.5
        },
        {
          'id' => 2,
          'name' => 'Salt',
          'price' => 1.5
        }
      ]
    end

    it "successfully returns all products in category" do
      get category_products_path(1)
      expect(response).to have_http_status(200)
      expect(parsed_response).to eq(expected_json)
    end
  end

  describe "POST /categories/:category_id/products" do
    let(:valid_params) do
      {
        product: {
          name: 'Butter',
          price: 3.50
        }
      }
    end

    context "valid params for new product" do
      let(:expected_json) do
        {
          'id' => 3,
          'name' => 'Butter',
          'price' => 3.5
        }
      end

      it 'creates new product' do
        expect { post category_products_path(1), params: valid_params }.to change(Product, :count).by(+1)
        expect(response).to have_http_status(201)
        expect(parsed_response).to eq(expected_json)
      end
    end

    context "blank name, blank price" do
      let(:expected_json) do
        {
          'errors' => {
            'name' => [
              "can't be blank"
            ],
            'price' => [
              "can't be blank",
              "is not a number"
            ]
          }
        }
      end

      it 'blank name and blank price both cause errors' do
        expect { post category_products_path(1), params: valid_params.merge(product: { name: nil, price: nil }) }.
          to change(Product, :count).by(0)
        expect(response).to have_http_status(422)
        expect(parsed_response).to eq(expected_json)
      end
    end

    context "name is not unique, price is not greater than 0" do
      let(:expected_json) do
        {
          'errors' => {
            'name' => [
              "has already been taken"
            ],
            'price' => [
              "must be greater than 0"
            ]
          }
        }
      end

      it 'not unique name and wrong price both cause errors' do
        expect { post category_products_path(1), params: valid_params.merge(product: { name: 'Salt', price: 0 }) }.
          to change(Product, :count).by(0)
        expect(response).to have_http_status(422)
        expect(parsed_response).to eq(expected_json)
      end
    end
  end

  describe "DELETE /products/:id" do
    it 'deletes product on request' do
      expect { delete '/products/1' }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(204)
    end
  end
end
