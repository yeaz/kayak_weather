class City < ActiveRecord::Base

  # *** ASSOCIATIONS *** #
  has_many :distances
  has_many :destinations, through: :distances
  
  # *** ATTR_ACCESSIBLE *** #
  attr_accessible :name, :state, :lat, :lng
  
end
