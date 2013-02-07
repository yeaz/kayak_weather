class Place < ActiveRecord::Base

  # *** ASSOCIATIONS *** #
  has_many :distances
  has_many :destinations, through: :distances
  
  # *** ATTR_ACCESSIBLE *** #
  attr_accessible :name, :lat, :lng
  
end
