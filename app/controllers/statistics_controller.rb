class StatisticsController < ApplicationController
  def index
    scope = Logbook.all

    today      = Time.zone.today
    @today     = scope.where(created_at: today.all_day).sum(:amount)
    @this_week = scope.where(created_at: today.all_week).sum(:amount)
    @this_month = scope.where(created_at: today.all_month).sum(:amount)
    @total     = scope.where(cup_type: 'Coffee').sum(:amount)

    @cups_per_day = scope
      .group_by_day(:created_at, last: 14)
      .sum(:amount)

    @cups_per_month = scope
      .group_by_month(:created_at, last: 6)
      .sum(:amount)

    @cups_by_type = scope
      .group(:cup_type)
      .sum(:amount)
      .sort_by { |_, v| -v } # meistgetrunkene zuerst

    @first_entry_date = scope.minimum(:created_at)&.to_date

        # 👉 Cups per Package (nur verbrauchte Pakete, offene werden ignoriert)
    package_entries = scope
      .where(cup_type: ["Probe Package", "Plauen Gold Package"])
      .where.not(package_size_grams: nil)
      .order(:created_at)

    @packages_detailed       = []
    @cups_per_package_chart  = []
    @avg_cups_by_size        = {}
    size_buckets             = Hash.new { |h, k| h[k] = [] }

    # Wenn weniger als 2 Pakete existieren, gibt es kein "verbraucht" (kein Nachfolger)
    if package_entries.size >= 2
      package_entries.each_with_index do |package, index|
        # letztes Paket ist das offene → überspringen
        next if index == package_entries.size - 1

        start_time = package.created_at
        end_time   = package_entries[index + 1].created_at

        coffees_in_package = scope
          .where(cup_type: "Coffee")
          .where(created_at: start_time..end_time)
          .sum(:amount)

        size = package.package_size_grams

        @packages_detailed << {
          cup_type: package.cup_type,
          size:     size,
          opened_at: start_time,
          coffees:  coffees_in_package
        }

        # Daten für Chart "Cups per Package"
        label = "#{size}g (#{I18n.l(start_time.to_date)})"
        @cups_per_package_chart << [label, coffees_in_package]

        # Daten für Durchschnitt je Größe
        size_buckets[size] << coffees_in_package
      end

      @avg_cups_by_size = size_buckets.transform_values do |coffees|
        avg = coffees.sum.to_f / coffees.size
        { avg_cups: avg, packages: coffees.size }
      end
    end

    # Für Chart "Avg cups by size": z. B. 250g → 27.5, 500g → 54.3
    @avg_cups_by_size_chart = @avg_cups_by_size.map do |size, data|
      ["#{size}g", data[:avg_cups].round(1)]
    end
  end
end