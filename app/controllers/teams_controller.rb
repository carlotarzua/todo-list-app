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
        redirect_to @team, notice: 'Team was successfully created.'
      else
        # Debugging team creation error
        Rails.logger.debug @team.errors.full_messages
        render :new, status: :unprocessable_entity
      end
    end
    
    # PATCH/PUT /teams/:id
    def update
      if @team.update(team_params)
        redirect_to @team, notice: 'Team was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @team = Team.find(params[:id])
      @team.destroy
      redirect_to teams_path, notice: 'Team was successfully deleted.'
    end
        
    private
  
    def set_team
      @team = Team.find(params[:id])
    end
  
    def team_params
      params.require(:team).permit(:name, :description)
    end
  end
  