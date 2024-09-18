class TodosController < ApplicationController
  before_action :set_todo, only: [ :edit, :update, :destroy ]
  def new
    @todo = ToDo.new
  end

  def create
    @todo = ToDo.new(todo_params)

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
    @todos = ToDo.all

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
        END"), :due_date
      )
    else
      @todos = @todos.order(:due_date)
    end
  end

  private

  def set_todo
    @todo = ToDo.find(params[:id])
  end

  def todo_params
    params.require(:to_do).permit(:title, :description, :due_date, :priority, :completed)
  end
end
