class WaresController < ApplicationController
  before_action :set_ware, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, except: [ :process_ware ]

  # GET /wares
  # GET /wares.json
  def index
    @wares = Ware.all
  end

  # GET /wares/1
  # GET /wares/1.json
  def show
  end

  # GET /wares/new
  def new
    @ware = Ware.new
  end

  # GET /wares/1/edit
  def edit
  end

  # POST /wares
  # POST /wares.json
  def create
    @ware = Ware.new(ware_params)

    respond_to do |format|
      if @ware.save
        format.html { redirect_to @ware, notice: 'Ware was successfully created.' }
        format.json { render :show, status: :created, location: @ware }
      else
        format.html { render :new }
        format.json { render json: @ware.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wares/1
  # PATCH/PUT /wares/1.json
  def update
    respond_to do |format|
      if @ware.update(ware_params)
        format.html { redirect_to @ware, notice: 'Ware was successfully updated.' }
        format.json { render :show, status: :ok, location: @ware }
      else
        format.html { render :edit }
        format.json { render json: @ware.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wares/1
  # DELETE /wares/1.json
  def destroy
    if @ware.available?
      @ware.destroy
      redirect_to wares_url, notice: 'Ware was successfully destroyed.'
    else
      redirect_to wares_url, notice: "Ware cannot be deleted."
    end
  end

  def process_ware
    ware = Ware.find(params[:ware_id])
    if ware.available?
      ware.update!(status: :processing)
      session[:processed_ware] = ware.id
      @wares = Ware.where(status: :available).order(:created_at)
      ActionCable.server.broadcast 'warehouse', { html: render_to_string('warehouse/index', layout: false) }
      redirect_to new_order_url
    else
      session[:processed_ware] = nil
      redirect_to warehouse_index_url, notice: "Item no longer available."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ware
      @ware = Ware.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ware_params
      params.require(:ware).permit(:name, :description, :price_cents, :image)
    end
end
