class TodosController < ApplicationController
  before_action :set_todo, only: [ :edit, :update, :destroy ]
  def new
    @todo = ToDo.new
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

  private

  def set_todo
    @todo = ToDo.find(params[:id])
  end

  def todo_params
    params.require(:to_do).permit(:title, :description, :due_datetime, :priority, :reminder, :completed)
  end

  def convert_to_central_time(datetime)
    datetime.in_time_zone('Central Time (US & Canada)')
  end
end
