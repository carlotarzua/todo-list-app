class Category < ApplicationRecord
    has_many :to_dos, dependent: :nullify
    validates :name, presence: true, uniqueness: true
end
