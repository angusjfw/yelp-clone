require 'rails_helper'

describe Restaurant, type: :model do
  let!(:restaurant){Restaurant.create(name: "Moe's Tavern")}

  it { is_expected.to have_many :reviews }

  it 'is not valid with a name of less than three characters' do
    bad_restaurant = Restaurant.new(name: "kf")
    expect(bad_restaurant).to have(1).error_on(:name)
    expect(bad_restaurant).not_to be_valid
  end

  it "is not valid unless it has a unique name" do
    copy_restaurant = Restaurant.new(name: "Moe's Tavern")
    expect(copy_restaurant).to have(1).error_on(:name)
  end

  describe '#average_rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context 'mixex reviews' do
      it 'returns average rating' do
        Review.create(restaurant: restaurant, rating: 3)
        Review.create(restaurant: restaurant, rating: 5)
        expect(restaurant.average_rating).to eq 4
      end
    end
  end
end
