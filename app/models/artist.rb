class Artist < ApplicationRecord
  has_many :songs, inverse_of: :artist, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validate :name_present
  accepts_nested_attributes_for :songs, reject_if: :all_blank

  def name_present
    return if name.nil? || name.empty?
    a = artist_search
    errors.add(:base, 'Must be a valid artist in Spotify') if a.empty?
  end

  def related_artists
    artist = artist_search[0]
    if artist.nil?
      nil
    else
      related_artists = artist.related_artists
      array = related_artists.map(&:name)
      array
    end
  end

  def top_tracks
    artist = artist_search[0]
    if artist
      top_tracks = artist.top_tracks(:US)
      array = top_tracks.map(&:name)
      array.map do |item|
        if item.include?('(')
          item.slice(0..(item.index'(') - 1).strip
        else
          item
        end
      end
    end
  end

  private

  def artist_search
    RSpotify::Artist.search(name)
  end
end
