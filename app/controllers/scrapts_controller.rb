class ScraptsController < ApplicationController
  def home
  end

  # POST /search
  def search
    

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

end
