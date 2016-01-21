class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, dependent: :destroy
	validates :name, length: {minimum: 3}, uniqueness: true

  def created_by?(user)
    user == self.user
  end
  
  def average_rating
    return 'N/A' if self.reviews.empty?
    reviews.reduce(0){ |sum, review| sum + review.rating }/reviews.length
  end
end
