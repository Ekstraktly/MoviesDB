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
    new_path = 'https://s3.eu-west-3.amazonaws.com/moviesdbstorage/' + image_name
    #binding.pry  and after two interations disable-pry
    saved_image = s3.put_object(bucket: ENV['S3_BUCKET_NAME'], key: image_name, body: download)
    avatar.attach(io: File.open(open(new_path)), filename: name, content_type: 'image/jpg')
    #avatar.attach(File.open(new_path))
  end

  def self.search(term)
    if term
      where('title ILIKE ?', "%#{term}%")
    else
      order(:title)
    end
  end
end
