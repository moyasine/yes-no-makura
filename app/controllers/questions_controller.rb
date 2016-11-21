class QuestionsController < ApplicationController
  before_action :set_question, only: [:edit, :update, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    if params[:id] == '0' then
      if Question.where(state: 'init').count == 0
        redirect_to action: 'not_find'
        return
      else
        @question = Question.find_by!(state: 'init')
        @question.state = "open"
        if @question.save
          redirect_to @question
          return
        end
      end
    end
    @question = Question.find(params[:id])
  end



  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      @question.state = params[:question][:state]
      if @question.save
        format.html { redirect_to questions_url, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to questions_url, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def result
    @question = Question.find_by!(id: params[:id])
    @answers_count = Answer.where(question: @question).where(yes: true).count
    @number_of_participant = NumberOfParticipant.first
  end

  def close
    @question = Question.find(params[:id])
    @question.state = "close"
    if @question.save
      redirect_to controller: 'questions', action: 'result', id: @question.id
    else
      redirect_to ({ action: 'show' }), alert: 'error'
    end

    def not_find
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:body, :state)
    end
end