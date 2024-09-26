class ToDo < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    validates :due_datetime, presence: true
    validates :priority, presence: true
    validates :reminder, presence: true
    validates :email, presence: true

    after_save :reminder_sender, if: -> { reminder != "None" }
    def reminder_sender
        reminder_time = case reminder
        when "1 hour" then 1.hour
        when "1 day" then 1.day
        when "1 week" then 1.week
        else return
        end
        ReminderJob.set(wait_until: due_datetime - reminder_time).perform_later(self)
    end
end
