require 'rails_helper'

describe ReviewsController, type: :controller do
  describe 'checking user is logged in before adding reviews' do
    it { is_expected.to use_before_action :authenticate_user! }
  end

  describe 'do not allow repeat reviews' do
    it { is_expected.to use_before_action :reject_repeat_reviews }
  end
end
