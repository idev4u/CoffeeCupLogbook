class LogbooksController < ApplicationController

  def index
    # @logbooks = Logbook.all
    @logbooks = Logbook.where(cup_type: 'Coffee')
    @package_logbook = Logbook.where(cup_type: 'Plauen Gold Package')
    @logbook_sum = 0
    @logbooks.each do | logbook |
      @logbook_sum=@logbook_sum+logbook.amount
    end

    puts "XXX: #{@package_logbook}"
    @package_logbook_sum = 0

    @package_logbook.each do | package |
      @package_logbook_sum=@package_logbook_sum+package.amount
    end
    puts "XXX: #{@package_logbook_sum}"

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
      # redirect_to @logbook
      redirect_to root_path, notice: "Eintrag erfolgreich erstellt."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def logbook_params
    params.require(:logbook).permit(
      :cup_type,
      :amount,
      :package_size_grams
    )
  end
end
