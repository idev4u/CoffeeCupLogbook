class LogbooksController < ApplicationController
  def index
    # @logbooks = Logbook.all
    @logbooks = Logbook.where(cup_type: "Coffee")
    @package_logbook = Logbook.where(cup_type: "Plauen Gold Package")
    # @logbook_sum = 0
    # @logbooks.each do | logbook |
    #   @logbook_sum=@logbook_sum+logbook.amount
    # end
    @logbook_sum = Logbook.where(cup_type: "Coffee").sum(:amount)

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
    # if @logbook.save
    #   # redrect to index fix this
    #   # redirect_to @logbook
    #   redirect_to root_path, notice: "Eintrag erfolgreich erstellt."
    # else
    #   render :new, status: :unprocessable_entity
    # end
    if @logbook.save
      if params[:quick_add] == "1"
        @logbook_sum = Logbook.where(cup_type: "Coffee").sum(:amount)
      end
      respond_to do |format|
      if params[:quick_add] == "1"
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Ein Kaffee hinzugefügt." }
      else
        format.html { redirect_to root_path, notice: "Eintrag erfolgreich erstellt." }
      end
    end
    else
      respond_to do |format|
        if params[:quick_add] == "1"
          format.turbo_stream { render "logbooks/create_error", status: :unprocessable_entity }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
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
