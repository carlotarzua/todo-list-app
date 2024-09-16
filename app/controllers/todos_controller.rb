class TodosController < ApplicationController
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

  private

  def todo_params
    params.require(:to_do).permit(:title, :description, :due_date)
  end
end
