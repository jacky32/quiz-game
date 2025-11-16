class PlaythroughsController < ApplicationController
  before_action :set_playthrough, only: %i[ show ]

  def show
  end

  def update
    if @playthrough.update(playthrough_params)
      redirect_to @playthrough, notice: "Playthrough was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_playthrough
    @playthrough = Current.user.playthroughs.in_progress.last || Current.user.playthroughs.create!
  end
end
