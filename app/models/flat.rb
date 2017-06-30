class Flat < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode

  mount_uploader :photo, PhotoUploader
end
