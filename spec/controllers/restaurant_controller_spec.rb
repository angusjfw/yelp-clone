require 'rails_helper'

describe RestaurantsController, type: :controller do
  describe 'checking user is logged in before adding or editing restaurants' do
    it { is_expected.to use_before_action :authenicate_user! }
  end

  describe 'checking user is permitted before editing' do
    it { is_expected.to use_before_action :check_creator } 
  end
end
