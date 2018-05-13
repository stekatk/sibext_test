require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:parsed_response) { JSON.parse response.body }
  let!(:category) { create :category }

  describe "GET /categories" do
    let!(:second_category) { create :category, name: 'Drinks' }
    let(:expected_json) do
      [
        {
          'id' => 1,
          'name' => 'Food',
          'products_count' => 0
        },
        {
          'id' => 2,
          'name' => 'Drinks',
          'products_count' => 0
        }
      ]
    end

    it "successfully returns all categories" do
      get categories_path
      expect(response).to have_http_status(200)
      expect(parsed_response).to eq(expected_json)
    end

    it "shows right products_count for category" do
      category.products << create(:product)
      get categories_path
      expect(parsed_response[0]['products_count']).to eq(1)
    end
  end

  describe "POST /categories" do
    let(:valid_params) do
      {
        category: {
          name: 'Drinks'
        }
      }
    end

    context "valid params for new category" do
      let(:expected_json) do
        {
          'id' => 2,
          'name' => 'Drinks',
          'products_count' => 0
        }
      end

      it 'creates new category' do
        expect { post categories_path, params: valid_params }.to change(Category, :count).by(+1)
        expect(response).to have_http_status(201)
        expect(parsed_response).to eq(expected_json)
      end
    end

    context "blank category name" do
      let(:expected_json) do
        {
          'errors' => {
            'name' => [
              "can't be blank"
            ]
          }
        }
      end

      it 'can not create new category with blank name' do
        expect { post categories_path, params: valid_params.merge(category: { name: nil }) }.
          to change(Category, :count).by(0)
        expect(response).to have_http_status(422)
        expect(parsed_response).to eq(expected_json)
      end
    end

    context "not unique category name" do
      let(:expected_json) do
        {
          'errors' => {
            'name' => [
              "has already been taken"
            ]
          }
        }
      end

      it 'can not create new category if name is not unique' do
        expect { post categories_path, params: valid_params.merge(category: { name: 'Food' }) }.
          to change(Category, :count).by(0)
        expect(response).to have_http_status(422)
        expect(parsed_response).to eq(expected_json)
      end
    end
  end
end
