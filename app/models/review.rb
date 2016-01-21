class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
  validates :rating, inclusion: (1..5)

  def created_by?(user)
    user == self.user
  end
end
