class Song < ApplicationRecord
  belongs_to :artist
  validates :name, presence: true
  validate :track_present
  validates_uniqueness_of :name, scope: :artist

  def track_present
    return if artist.nil? || name.nil? || artist.name.nil? || name.empty?
    s = song_search
    song_search
    if s.empty?
      errors.add(:base, 'Must be a valid song for the artist in Spotify')
    end
  end

  def spotify_uri
    song1 = song_search[0]
    if song1.nil?
      nil
    else
      return song1.uri
    end
  end

  private

  def song_search
    RSpotify::Track.search("#{artist.name} #{name}")
  end
end
