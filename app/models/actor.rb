class Actor < ApplicationRecord
  has_many :roles, dependent: :destroy
  has_many :movies, through: :roles

  validates :name, length: 2..45, presence: true
end