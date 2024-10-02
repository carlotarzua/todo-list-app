class TodosController < ApplicationController
  before_action :set_todo, only: [ :edit, :update, :destroy, :start_timer, :stop_timer, :archive ]
  before_action :set_team, only: [:team_todos]

  def new
    @todo = ToDo.new
    @team = Team.find(params[:team_id]) if params[:team_id]
  end

  def create
    @todo = ToDo.new(todo_params)
    @todo.email = current_user.email
    config.time_zone = "Central Time (US & Canada)"
    @todo.due_datetime = convert_to_central_time(@todo.due_datetime) if @todo.due_datetime.present?

    if @todo.save
      redirect_to todos_path, notice: "ToDo item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @todo bject set by the before_action
  end

  def update
    @todo.due_datetime = convert_to_central_time(todo_params[:due_datetime]) if todo_params[:due_datetime].present?
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "ToDo item was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_path, notice: "ToDo item was succesfully deleted"
  end

  def index
    @todos = ToDo.where(email: current_user.email)

    if params[:search].present?
      @todos = @todos.where("title LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end

    if params[:category_id].present?
      @todos = @todos.where(category_id: params[:category_id])

    if params[:team_id].present?
      @todos = @todos.where(team_id: params[:team_id])
    end
    
  end

    if params[:sort] == "priority"
      @todos = ToDo.order(
        Arel.sql("CASE priority
          WHEN 'high' THEN 1
          WHEN 'medium' THEN 2
          WHEN 'low' THEN 3
          ELSE 4
        END"), :due_datetime
      )
    else
      @todos = @todos.order(:due_datetime)
    end
  end

  def start_timer
    @todo.start_timer
    redirect_to todos_path, notice: "Timer started for '#{@todo.title}'."
  end

  def stop_timer
    @todo.stop_timer
    redirect_to todos_path, notice: "Timer stopped for '#{@todo.title}'. Total time updated."
  end

  def archive
    @to_do = ToDo.find(params[:id])
    if @todo.update(archived: true)
      redirect_to todos_path, notice: "Item succesfully archived."
    else
      redirect_to todos_path, notice: "Failed to archive item"
    end
  end

  def archived
    @archived_to_dos = ToDo.archived.where(email: current_user.email)
  end

  private

  def set_todo
    @todo = ToDo.find(params[:id])
  end

  def todo_params
    params.require(:to_do).permit(:title, :description, :due_datetime, :priority, :reminder, :completed, :category_id, :progress, :team_id)
  end

  def convert_to_central_time(datetime)
    datetime.in_time_zone("Central Time (US & Canada)")
  end

  def team_todos
    if @team.nil?
      redirect_to teams_path, alert: "Team not found."
      return
    end
    @todos = ToDo.where(team_id: @team.id)
    Rails.logger.debug("ToDos fetched: #{@todos.to_a}")
  end

  def set_team
    @team = Team.find_by(id: params[:id])
    redirect_to teams_path, alert: "Team not found." if @team.nil?
  end

end
