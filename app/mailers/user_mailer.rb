class UserMailer < ApplicationMailer
    default from: "todoappgroup3@gmail.com"

    def invite_user(user, team)
      @user = user
      @team = team

      mail(to: @user.email, subject: "You're Invited to Join #{@team.name} Team!")
    end
end
