class SharedListsController < ApplicationController
    before_action :set_team
    before_action :set_shared_list, only: [ :show, :edit, :update, :destroy, :new_todo, :create_todo ]

    def index
        @shared_lists = @team.shared_lists
    end

    def show
        @shared_lists = @team.shared_lists.find(params[:id])
    end

    def new
        @shared_lists = @team.shared_lists.new
    end

    def create
        @shared_list = @team.shared_lists.new (shared_list_params)
        if @shared_list.save
            redirect_to team_shared_lists_path(@team), notice: "Shared List created successfully."
        else
            render :new
        end
    end

    def edit
        @shared_list = @team.shared_lists.find(params[:id])
    end

    def update
        @shared_list = @team.shared_lists.find(params[:id])
    if @shared_list.update(shared_list_params)
        redirect_to team_shared_list_path(@team, @shared_list), notice: "Shared list updated successfully."
    else
        render :edit
    end
    end

    def destroy
        @shared_list = @team.shared_lists.find(params[:id])
        @shared_list.destroy
        redirect_to team_shared_lists_path(@team), notice: "Shared list deleted successfully."
    end

    private

    def set_team
        @team = Team.find(params[:team_id])
    end

    def shared_list_params
        params.require(:shared_list).permit(:name)
    end

    def new_todo
        @to_do = @shared_list.to_dos.new
      end

    def create_todo
        @to_do = @shared_list.to_dos.new(to_do_params)
        @to_do.email = current_user.email  # Set the email of the user creating the todo

        if @to_do.save
            redirect_to team_shared_list_path(@team, @shared_list), notice: "ToDo was successfully created."
        else
            render :new_todo
        end
    end

    private

    def set_shared_list
      @shared_list = @team.shared_lists.find(params[:id])
    end

    def to_do_params
      params.require(:to_do).permit(:title, :description, :priority, :due_datetime)  # Add other permitted attributes as needed
    end
end
