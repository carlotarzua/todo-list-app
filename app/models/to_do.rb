class ToDo < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    validates :due_date, presence: true
    validates :priority, presence: true
end
