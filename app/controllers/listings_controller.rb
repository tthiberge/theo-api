class ListingsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create

  end

  def edit
  end

  def update
  end

  def destroy
  end
end


def user_not_authorized(exception)
  render json: {
    error: "Unauthorized #{exception.policy.class.to_s.underscore.camelize}.#{exception.query}"
  }, status: :unauthorized
end
