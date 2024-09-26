class ReminderJob < ApplicationJob
  queue_as :default

  def perform(todo)
    # Do something later
    ReminderMailer.reminder(todo).deliver_now
  end
end
