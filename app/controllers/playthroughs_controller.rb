class PlaythroughsController < ApplicationController
  before_action :set_playthrough

  def show
    @current_level = @playthrough.playthroughs_questions.answered.count + 1
  end

  def answer_question
    @selected_option = @playthrough.current_question.question_options.find_by(uuid: playthrough_params[:question_option_id])
    if @selected_option.nil?
      redirect_to playthroughs_path, alert: "Vybraná možnost není platná."
      return
    end
    case @playthrough.answer_current_question(@selected_option)
    when :correct_answer
      redirect_to playthroughs_path, notice: "Správná odpověď!"
    when :finished
      redirect_to root_path, notice: "Hra dokončena! Vaše konečné skóre je #{@playthrough.score}."
    when :incorrect_answer
      redirect_to root_path, alert: "Špatná odpověď. Hra byla ukončena, vaše skóre je #{@playthrough.score}."
    end
  end

  def use_text_hint
  end

  def use_fifty_hint
  end

  def use_question_swap
  end

  private

  def set_playthrough
    @playthrough = Current.user.playthroughs.in_progress.last || Current.user.playthroughs.create!
  end

  def playthrough_params
    params.expect(playthrough: [ :question_option_id ])
  end
end
