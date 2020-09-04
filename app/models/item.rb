class Item < ApplicationRecord

  has_one :seller, class_name: "Seller", foreign_key: "item_id", dependent: :destroy
  has_one :buyer, class_name: "Buyer", foreign_key: "item_id", dependent: :destroy
  belongs_to :category
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :name, presence: true,  length: { maximum: 50 }
  validates :description, presence: true, length:{ maximum: 100}
  validates :price, numericality: { greater_than: 0 }


  private

end
