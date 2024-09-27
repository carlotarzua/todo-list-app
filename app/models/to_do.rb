class ToDo < ApplicationRecord
    belongs_to :category, optional: true

    validates :title, :description, :due_date, :priority, :reminder, :email, presence: true

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

    def start_timer
        update(start_time: Time.now)
    end

    def stop_timer
        if start_time
            time_spent = Time.now - start_time
            update(total_time: total_time + time_spent.to_i, start_time: nil, end_time: Time.now)
        end
    end

    def formatted_total_time
        total_seconds = self.total_time || 0
        hours = total_seconds / 3600
        minutes = (total_seconds % 3600) / 60
        seconds = total_seconds % 60
        "#{hours}h #{minutes}m #{seconds}s"
    end
end
