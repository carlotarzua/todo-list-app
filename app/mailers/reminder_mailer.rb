class ReminderMailer < ApplicationMailer
    def reminder(todo)
        @todo = todo
        mail(
            to: @todo.email,
            subject: "ToDo App Reminder: The due date for #{@todo.title} is #{@todo.reminder} away!"
        )
    end
end
