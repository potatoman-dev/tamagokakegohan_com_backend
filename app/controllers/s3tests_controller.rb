class S3testsController < ApplicationController
  def create
    s3test = S3test.new(s3test_params)
    if s3test.save
      render json: { status: 'success', s3test: s3test }, status: :created
    else
      render json: { status: 'error', errors: s3test.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def s3test_params
    params.require(:s3test).permit(:image)
  end
end
