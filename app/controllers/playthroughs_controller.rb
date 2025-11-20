class PlaythroughsController < ApplicationController
  before_action :set_playthrough

  def show
    @playthrough_won = params[:won].present?
    @playthrough_lost = params[:lost].present?
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
      redirect_to playthroughs_path(won: true), notice: "Hra dokončena! Vaše konečné skóre je #{@playthrough.score}."
    when :incorrect_answer
      redirect_to playthroughs_path(lost: true), alert: "Špatná odpověď. Hra byla ukončena, vaše skóre je #{@playthrough.score}."
    end
  end

  def use_text_hint
    redirect_to playthroughs_path, alert: "Textová nápověda již byla použita." and return if @playthrough.text_hint_used?

    if @playthrough.use_text_hint
      redirect_to playthroughs_path, notice: "Textová nápověda byla úspěšně použita. Pro otevření klikněte na \"Otevřít nápovědu\"."
    else
      redirect_to playthroughs_path, alert: "Nepodařilo se použít textovou nápovědu."
    end
  end

  def use_fifty_hint
    redirect_to playthroughs_path, alert: "Nápověda 50:50 již byla použita." and return if @playthrough.fifty_hint_used?

    if @playthrough.use_fifty_hint
      redirect_to playthroughs_path, notice: "Nápověda 50:50 byla úspěšně použita."
    else
      redirect_to playthroughs_path, alert: "Nepodařilo se použít nápovědu 50:50."
    end
  end

  def use_question_swap
    redirect_to playthroughs_path, alert: "Výměna otázky již byla použita." and return if @playthrough.question_swap_used?

    if @playthrough.use_question_swap
      redirect_to playthroughs_path, notice: "Výměna otázky byla úspěšně použita."
    else
      redirect_to playthroughs_path, alert: "Nepodařilo se použít výměnu otázky."
    end
  end

  private

  def set_playthrough
    @playthrough = Current.user.playthroughs.in_progress.last || Current.user.playthroughs.create!
  end

  def playthrough_params
    params.expect(playthrough: [ :question_option_id ])
  end
end
