class TeamsController < ApplicationController
    before_action :set_team, only: %i[show edit update destroy]
    before_action :authenticate_user!

    # GET /teams
    def index
      @teams = current_user.teams  # Get all teams the current user belongs to
    end

    # GET /teams/:id
    def show
      # Displays team details
    end

    # GET /teams/new
    def new
      @team = Team.new
    end

    def create
      @team = Team.new(team_params)

      @team.user_id = current_user.id
      @team.owner_id = current_user.id

      if @team.save
        @team.users << current_user
        redirect_to @team, notice: "Team was successfully created."
      else
        # Debugging team creation error
        Rails.logger.debug @team.errors.full_messages
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /teams/:id
    def update
      if @team.update(team_params)
        redirect_to @team, notice: "Team was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @team = Team.find(params[:id])

      if @team.owner_id == current_user.id
        @team.destroy
        redirect_to teams_path, notice: "Team was successfully deleted."
      else
        redirect_to @team, alert: "You are not authorized to delete this team."
      end
    end

    # POST /teams/:id/invite
    def invite
      email = params[:email]
      @team = Team.find(params[:id])

      if email.present?
        user = User.find_by(email: email)

        if user
          if @team.users.include?(user)  # Check if the user is already a member of the team
            flash[:alert] = "#{email} is already a member of the team."
          else
            UserMailer.invite_user(user, @team).deliver_later
            flash[:notice] = "Invitation sent to #{email}."
          end
        else
          flash[:alert] = "No user found with the email: #{email}."
        end
      else
        flash[:alert] = "Please enter a valid email address."
      end

      redirect_to @team
    end


  # GET /teams/:id/join
  def join
    user = current_user
    @team = Team.find(params[:id])

    unless @team.users.include?(user)
      @team.users << user
      flash[:notice] = "You have successfully joined the team!"
    else
      flash[:alert] = "You are already a member of this team."
    end

    redirect_to teams_path
  end

    private

    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :description)
    end
end
