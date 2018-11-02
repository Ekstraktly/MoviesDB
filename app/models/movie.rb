require 'open-uri'

class Movie < ApplicationRecord
  belongs_to :genre, optional: true
  has_many :roles, dependent: :destroy
  has_many :actors, through: :roles

  has_one_attached :avatar

  validates :title, length: 2..45, presence: true

  def grab_image(url, name)
    download = open(url)
    new_path = Rails.root + "images/#{download.base_uri.to_s.split('/')[-1]}"
    IO.copy_stream(download, new_path)
    #binding.pry  and after two interations disable-pry
    avatar.attach(io: File.open(new_path), filename: name, content_type: 'image/jpg')
    avatar.attach(File.open(new_path))
  end

  def self.search(term)
    if term
      where('title ILIKE ?', "%#{term}%")
    else
      order(:title)
    end
  end
end
