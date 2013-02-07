class Distance < ActiveRecord::Base

  # *** ASSOCIATIONS *** #
  belongs_to :origin, class_name: 'Place', foreign_key: 'origin_id'
  belongs_to :destination, class_name: 'Place', foreign_key: 'destination_id'
  
  # *** ATTR_ACCESSIBLE *** #
  attr_accessible :origin_id, :destination_id, :value 

end
