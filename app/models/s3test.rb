class S3test < ApplicationRecord
  mount_uploader :image, S3TestUploader
end
