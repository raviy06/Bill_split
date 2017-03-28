class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :name, :email, :password, presence: :true
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :name, uniqueness: :true
  
  has_many :guests
  has_many :entries, through: :guests

  has_many :credits,
    :class_name => "Settlement",
    :foreign_key => :payee_id

  has_many :debts,
    :class_name => "Settlement",
    :foreign_key => :receiver_id
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
