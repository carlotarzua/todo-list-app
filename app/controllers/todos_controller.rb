class TodosController < ApplicationController
  before_action :set_todo, only: [:edit, :update, :destroy]

  def new
    @todo = ToDo.new
  end

  def create
    @todo = ToDo.new(todo_params)

    if @todo.save
      redirect_to new_todo_path, notice: "ToDo item was successfully created."
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
    @todos = if params[:sort] == 'priority'
      ToDo.order(:priority)
    else
      ToDo.order(:due_date)
    end
  end

  private

  def set_todo
    @todo = ToDo.find(params[:id])
  end

  def todo_params
    params.require(:to_do).permit(:title, :description, :due_date)
  end
end
