class Admin::QuestionsController < Admin::BaseController
  before_action :set_question, only: %i[ show edit update destroy ]

  # GET /questions
  def index
    @questions = Question.all
  end

  # GET /questions/1
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    @question.build_correct_option
    3.times { @question.incorrect_options.build }
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  def create
    @question = Question.new(question_params)
    @question.creator = Current.user

    if @question.save!
      redirect_to admin_questions_path, notice: "Otázka byla úspěšně vytvořena."
    else
      flash.now[:alert] = "Něco se pokazilo. Zkontrolujte formulář."
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to admin_questions_path, notice: "Otázka byla úspěšně upravena.", status: :see_other
    else
      flash.now[:alert] = "Něco se pokazilo. Zkontrolujte formulář."
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy!
    redirect_to admin_questions_path, notice: "Úspěšně smazáno.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.expect(question: [
        :active,
        :body,
        :hint,
        :level,
        :name,
        question_options_attributes: [ :id, :text, :correct ] ])
    end
end
