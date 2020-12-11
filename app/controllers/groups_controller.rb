# frozen_string_literal: true

class GroupsController < SecureController
  before_action :set_group, only: %i[show edit update destroy]

  def index
    @groups = Group.all.includes(:category).page(params[:page])
  end

  def show; end

  def update
    if @group.update(group_params)
      redirect_to @group, success: 'Successfully updated group'
    else
      render :edit
    end
  end

  def edit; end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group, success: 'Successfully created group'
    else
      render :new
    end
  end

  def destroy
    if @group.destroy
      redirect_to groups_path, success: 'Successfully deleted group'
    else
      redirect_to groups_path, {
        error: 'Could not delete group. Please veify there are no articles.'
      }
    end
  end

  private

  def set_group
    @group = Group.includes(:articles, :category).find(params[:id])
  end

  def group_params
    params.require(:group).permit(:category_id)
  end
end
