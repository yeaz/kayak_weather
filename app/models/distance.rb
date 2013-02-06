class Distance < ActiveRecord::Base

  # *** ASSOCIATIONS *** #
  belongs_to :city
  belongs_to :destination, class_name: 'City', foreign_key: 'destination_id'
  
  # *** ATTR_ACCESSIBLE *** #
  attr_accessible :city_id, :destination_id, :value 

end
