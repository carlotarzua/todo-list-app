class Team < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_and_belongs_to_many :users
  has_many :to_dos, dependent: :destroy
  validates :name, presence: true
  validates :owner_id, presence: true
end
