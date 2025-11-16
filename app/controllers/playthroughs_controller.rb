class PlaythroughsController < ApplicationController
  before_action :set_playthrough, only: %i[ show edit update destroy ]

  # GET /playthroughs
  def index
    @playthroughs = Playthrough.all
  end

  # GET /playthroughs/1
  def show
  end

  # GET /playthroughs/new
  def new
    @playthrough = Playthrough.new
  end

  # GET /playthroughs/1/edit
  def edit
  end

  # POST /playthroughs
  def create
    @playthrough = Playthrough.new(playthrough_params)

    if @playthrough.save
      redirect_to @playthrough, notice: "Playthrough was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /playthroughs/1
  def update
    if @playthrough.update(playthrough_params)
      redirect_to @playthrough, notice: "Playthrough was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /playthroughs/1
  def destroy
    @playthrough.destroy!
    redirect_to playthroughs_path, notice: "Playthrough was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playthrough
      @playthrough = Playthrough.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def playthrough_params
      params.expect(playthrough: [ :user_id, :score, :status, :text_hint_used, :fifty_hint_user, :question_swap_used ])
    end
end
