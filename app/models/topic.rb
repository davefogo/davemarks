class Topic < ActiveRecord::Base
  belongs_to :user
  has_many :bookmarks, dependent: :destroy

  validates :user, presence: true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Topic.create! row.to_hash
    end
  end
end
