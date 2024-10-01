class SharedList < ApplicationRecord
  belongs_to :team
  has_many :to_dos, dependent: :destroy 
end
