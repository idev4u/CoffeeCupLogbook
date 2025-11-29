class LogbooksController < ApplicationController
  def index
    @logbooks = Logbook.all
  end
end
