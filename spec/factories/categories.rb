FactoryBot.define do
  factory :category do
    name "Food"
  end

  factory :another_category, parent: :category do
    name "Drinks"
  end

  factory :blank_name_category, parent: :category do
    name ""
  end
end
