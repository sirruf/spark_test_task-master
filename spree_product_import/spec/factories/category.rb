FactoryBot.define do
  factory :category, class: 'Spree::ShippingCategory' do
    name { FFaker::Lorem.word }
  end
end
