class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable
  has_many :teams, foreign_key: :owner_id
  has_and_belongs_to_many :teams
  has_many :shared_lists, through: :teams
end
