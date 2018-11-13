FactoryBot.define do
  factory :location, class: 'Spree::StockLocation' do
    name { FFaker::Lorem.word }
  end
end
