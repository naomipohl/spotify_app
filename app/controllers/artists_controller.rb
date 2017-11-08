class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :destroy, :related_artists, :top_tracks]

  def index
    @artists = Artist.all
  end

  def show
  end

  def new
    @artist = Artist.new
    3.times { @artist.songs.build }
  end

  def create
    @artist = Artist.new(artist_params)

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, notice: 'Artist was successfully created.' }
        format.json { render :show, status: :created, location: @artist }
      else
        format.html { render :new }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'Artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def related_artists
    @new_artist = Artist.new
  end

  def top_tracks
    @new_song = Song.new
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_artist
    @artist = Artist.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def artist_params
    params.require(:artist).permit(:name, songs_attributes: [:name])
  end
end
