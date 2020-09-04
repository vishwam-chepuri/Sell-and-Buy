class Buyer < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :item, class_name: "Item"
end
