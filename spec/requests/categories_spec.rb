require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:parsed_response) { JSON.parse response.body }
  let!(:category) { create :category }

  describe "GET /categories" do
    before { get categories_path }

    it { expect(response).to have_http_status(200) }
    it { expect(parsed_response).to eq([{"id"=>1, "name"=>"Food"}]) }
  end

  describe "POST /categories" do
    context "valid params for new category" do
      let(:valid_params) do
        {
          category: {
            name: 'Drinks'
          }
        }
      end

      before { post categories_path, params: valid_params}

      it { expect(response).to have_http_status(201) }
      it { expect(parsed_response).to eq({"id"=>2, "name"=>"Drinks"})}
    end

    context "blank category name" do
      let(:blank_name_params) do
        {
          category: {
            name: ''
          }
        }
      end

      before { post categories_path, params: blank_name_params }

      it { expect(response).to have_http_status(422) }
      it { expect(parsed_response).to eq({"errors"=>{"name"=>["can't be blank"]}}) }
    end

    context "blank category name" do
      let(:taken_name_params) do
        {
          category: {
            name: 'Food'
          }
        }
      end

      before { post categories_path, params: taken_name_params }

      it { expect(response).to have_http_status(422) }
      it { expect(parsed_response).to eq({"errors"=>{"name"=>["has already been taken"]}}) }
    end
  end
end
