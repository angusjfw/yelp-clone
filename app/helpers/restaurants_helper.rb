module RestaurantsHelper
  def star_rating(rating)
    return rating unless rating.is_a?(Numeric)
    remainder = (5 - rating.round)
    "\u2605" * rating.round + "\u2606" * remainder
  end
end
