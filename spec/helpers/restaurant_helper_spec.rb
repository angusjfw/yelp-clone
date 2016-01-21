require 'rails_helper'

describe RestaurantsHelper, :type => :helper do
  describe '#star_rating' do
    it 'does nothing for not a number' do
      expect(helper.star_rating('N/A')).to eq 'N/A'
    end

    it 'returns five black stars for five' do
        expect(helper.star_rating(5)).to eq "\u2605\u2605\u2605\u2605\u2605"
    end

    it 'returns three black stars and two white stars for three' do
      expect(helper.star_rating(3)).to eq "\u2605\u2605\u2605\u2606\u2606"
    end

    it 'returns four black stars and one white star for 3.5' do
        expect(helper.star_rating(3.5)).to eq "\u2605\u2605\u2605\u2605\u2606"

    end
  end
end
