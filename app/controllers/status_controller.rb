class StatusController < ApplicationController
  def index
    render json: {message: "available."}, status: :ok
  end
end
