class Actor < ApplicationRecord
  has_many :roles, dependent: :destroy
  has_many :movies, through: :roles

  validates :name, length: 2..45, presence: true

  def self.search(term)
    if term
      where('name ILIKE ?', "%#{term}%")
    else
      all
    end
  end
end