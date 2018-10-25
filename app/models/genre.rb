class Genre < ApplicationRecord
  has_many :movies, dependent: :destroy

  validates :name, length: 2..45,
                   presence: true,
                   uniqueness: { case_sensitive: false }

  def self.search(term)
    if term
      where('name ILIKE ?', "%#{term}%")
    else
      order(:name)
    end
  end
end