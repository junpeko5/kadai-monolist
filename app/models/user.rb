class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :ownerships
  has_many :items, through: :ownerships
  has_many :wants
  has_many :want_items, through: :wants, class_name: 'Item', source: :item
  has_many :gets
  has_many :get_items, through: :gets, class_name: 'Item', source: :item
  
  def want(item)
    self.wants.find_or_create_by(item_id: item.id)
  end
  
  def unwant(item)
    want = self.wants.find_by(item_id: item.id)
    want.destroy if want
  end
  
  def want?(item)
    self.want_items.include?(item)
  end
  
  def get(item)
    self.gets.find_or_create_by(item_id: item.id)
  end
  
  def unget(item)
    get = self.gets.find_by(item_id: item.id)
    get.destroy if get
  end
  
  def get?(item)
    self.get_items.include?(item)
  end
end
