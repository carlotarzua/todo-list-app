class ToDo < ApplicationRecord
    belongs_to :category, optional: true

    validates :title, :description, :due_date, :priority, presence: true
end
