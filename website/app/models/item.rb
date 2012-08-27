class Item < ActiveRecord::Base
  attr_accessible :description, :merchant_id, :price

  belongs_to :merchant
  has_many :purchases
  has_many :items, :through => :purchases
end
