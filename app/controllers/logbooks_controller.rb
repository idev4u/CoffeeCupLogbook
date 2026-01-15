class LogbooksController < ApplicationController
  def index
    # @logbooks = Logbook.all
    # @logbooks = Logbook.where(cup_type: "Coffee")

    today = Time.zone.today
    yesterday = today - 1.day

    @today_cups = Logbook.where(cup_type: "Coffee", created_at: today.all_day).sum(:amount)
    @yesterday_cups = Logbook.where(cup_type: "Coffee", created_at: yesterday.all_day).sum(:amount)
    @last_package_at = Logbook.where.not(package_size_grams: nil).order(created_at: :desc).pick(:created_at)
  end

  def show
    @logbook = Logbook.find(params[:id])
  end

  def new
    @logbook = Logbook.new
  end

  def create
    @logbook = Logbook.new(logbook_params)

    retroactive = params.dig(:logbook, :retroactive) == "1"
    opened_on = params.dig(:logbook, :opened_on)

    if retroactive && opened_on.present?
      begin
        opened_date = Date.iso8601(opened_on)
        if opened_date > Time.zone.today
          @logbook.errors.add(:base, "Datum darf nicht in der Zukunft liegen.")
        else
          timestamp = Time.zone.local(opened_date.year, opened_date.month, opened_date.day, 9, 0)
          @logbook.created_at = timestamp
          @logbook.updated_at = timestamp
        end
      rescue ArgumentError
        @logbook.errors.add(:base, "Datum ist ungueltig.")
      end
    end

    if @logbook.save
      if params[:quick_add] == "1"
        # @logbook_sum = Logbook.where(cup_type: "Coffee").sum(:amount)
        today = Time.zone.today
        @today_cups = Logbook.where(cup_type: "Coffee", created_at: today.all_day).sum(:amount)
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
      :package_size_grams,
      :opened_on,
      :retroactive
    )
  end
end
