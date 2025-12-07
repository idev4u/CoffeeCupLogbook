class StatisticsController < ApplicationController
  def index
    scope = Logbook.all

    today      = Time.zone.today
    @today     = scope.where(created_at: today.all_day).sum(:amount)
    @this_week = scope.where(created_at: today.all_week).sum(:amount)
    @this_month = scope.where(created_at: today.all_month).sum(:amount)
    @total     = scope.sum(:amount)

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
  end
end