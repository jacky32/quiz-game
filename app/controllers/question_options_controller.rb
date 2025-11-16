class QuestionOptionsController < ApplicationController
  before_action :set_question_option, only: %i[ show edit update destroy ]

  # GET /question_options
  def index
    @question_options = QuestionOption.all
  end

  # GET /question_options/1
  def show
  end

  # GET /question_options/new
  def new
    @question_option = QuestionOption.new
  end

  # GET /question_options/1/edit
  def edit
  end

  # POST /question_options
  def create
    @question_option = QuestionOption.new(question_option_params)

    if @question_option.save
      redirect_to @question_option, notice: "Question option was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /question_options/1
  def update
    if @question_option.update(question_option_params)
      redirect_to @question_option, notice: "Question option was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /question_options/1
  def destroy
    @question_option.destroy!
    redirect_to question_options_path, notice: "Question option was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question_option
      @question_option = QuestionOption.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def question_option_params
      params.expect(question_option: [ :question_id, :text, :correct ])
    end
end
