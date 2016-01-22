class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, dependent: :destroy
	validates :name, length: {minimum: 3}, uniqueness: true

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def created_by?(user)
    user == self.user
  end
  
  def average_rating
    return 'N/A' if self.reviews.empty?
    reviews.reduce(0){ |sum, review| sum + review.rating }/reviews.length
  end
end
