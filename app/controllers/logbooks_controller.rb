class LogbooksController < ApplicationController
  
  def index
    # @logbooks = Logbook.all
    @logbooks = Logbook.where(cup_type: 'Coffee')
    @logbook_sum = 0
    @logbooks.each do | logbook |
      @logbook_sum=@logbook_sum+logbook.amount
    end

  end

  def show
    @logbook = Logbook.find(params[:id])
  end

  def new
    @logbook = Logbook.new
  end

  def create
    @logbook = Logbook.new(logbook_params)
    puts "XXX: #{@logbook}"
    if @logbook.save
      # redrect to index fix this
      redirect_to @logbook
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def logbook_params
      params.require(:logbook).permit(:cup_type, :amount)
    end

end
