require 'open-uri'
require 'aws-sdk-s3'

class Movie < ApplicationRecord
  belongs_to :genre, optional: true
  has_many :roles, dependent: :destroy
  has_many :actors, through: :roles

  has_one_attached :avatar

  validates :title, length: 2..45, presence: true

  def grab_image(url, name, s3)

    download = open(url)
    image_name = download.base_uri.to_s.split('/')[-1]
    #new_path = Rails.root + "images/#{image_name}"
    new_path = 'https://s3-eu-west-3.amazonaws.com/moviesdbstorage/' + image_name
    #binding.pry  and after two interations disable-pry
    s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: image_name, body: download)
    saved_image= s3.get_object(bucket: ENV['S3_BUCKET_NAME'], key: image_name)
    #avatar.attach(io: saved_image.body, filename: name, content_type: 'image/jpg')
    avatar.attach(io: saved_image.body, filename: image_name)
  end

  def self.search(term)
    if term
      joins(:actors).where("concat_ws(' ', actors.name, title) ILIKE ?", "%#{term}%")
    else
      order(:title)
    end
  end
end
