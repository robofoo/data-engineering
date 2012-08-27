class Purchase < ActiveRecord::Base
  attr_accessible :count, :customer_id, :item_id
end
