class FlatsController < ApplicationController
  before_action :set_flat, only: [:show, :edit, :update, :destroy]
  before_action :identifica_mobile
  before_action :bloqueia_mobile, only: [:edit, :destroy]

  # GET /flats
  # GET /flats.json
  def index
    @flats = Flat.where.not(latitude: nil, longitude: nil)

    @hash = Gmaps4rails.build_markers(@flats) do |flat, marker|
      marker.lat flat.latitude
      marker.lng flat.longitude
      marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  # GET /flats/1
  # GET /flats/1.json
  def show
    @images = Dir.glob("public/uploads/flat/photo/#{@flat.id}/*")
  end

  # GET /flats/new
  def new
    @flat = Flat.new
  end

  # GET /flats/1/edit
  def edit
  end

  # POST /flats
  # POST /flats.json
  def create
    @flat = Flat.new(flat_params)

    if @flat.save
      redirect_to flats_path, notice: 'Flat was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /flats/1
  # PATCH/PUT /flats/1.json
  def update
    if @flat.update(flat_params)
      redirect_to @flat, notice: 'Flat was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /flats/1
  # DELETE /flats/1.json
  def destroy
    @flat.destroy
    respond_to do |format|
      format.html { redirect_to flats_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flat
      @flat = Flat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flat_params
      params.require(:flat).permit(:name, :address, :photo, :photo_cache)
    end

  def identifica_mobile
    # Verifica se o dispositivo conectado eh mobile
    request.user_agent.downcase.match(/intel mac os|ipad|windows/) ? @eh_mobile = false : @eh_mobile = true
  end

  def bloqueia_mobile
    # Bloqueia acesso indevido via celular
    redirect_to root_path if @eh_mobile
  end
end
