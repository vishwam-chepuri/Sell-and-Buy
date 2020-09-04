class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :sale_items, class_name: "Seller",foreign_key: "user_id", dependent: :destroy
  has_many :brought_items, class_name: "Buyer", foreign_key: "user_id", dependent: :destroy

  before_save { self.email = email.downcase }
  
  mount_uploader :picture, PictureUploader
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_MOBILE_REGEX = /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :phone, presence: true, length: {maximum: 13},#
                    format: {with: VALID_MOBILE_REGEX },
                    uniqueness: true
  validates :address, length: { maximum: 200 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 } #,allow_nil: true
  # validates :pin, presence: true
  

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  


  #OTP VERIFICATION

  def generate_pin
    gen_pin = rand(0000..9999).to_s.rjust(4, "0")
    update_attribute(:pin, gen_pin)
    save
  end

  def twilio_client
    #twilio_client = Twilio::REST::Client.new(APP_CONFIG[:TWILIO_ACCOUNT_SID], APP_CONFIG[:TWILIO_AUTH_TOKEN] 
    Twilio::REST::Client.new([:TWILIO_ACCOUNT_SID], [:TWILIO_AUTH_TOKEN]  )
  end

  def send_pin
    twilio_client.messages.create(
      to: phone,
      from: [:TWILIO_PHONE_NUMBER],#APP_CONFIG[:TWILIO_PHONE_NUMBER],
      body: "Your PIN is #{pin}"
    )
    #return pin
  end

  def verify(entered_pin)#,gen_pin)
    if pin == entered_pin
      update_attribute(:verified, true) 
    end
  end


  def feed
    items = Seller.where.not(user_id: self.id).pluck(:item_id)
    Item.where(id: items).where(sold: false)
  end
  

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end