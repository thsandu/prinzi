class BuchungsController < ApplicationController
  before_action :set_buchung, only: [:show, :edit, :update, :destroy]

  # GET /buchungs
  # GET /buchungs.json
  def index
    @buchungs = Buchung.all
  end

  # GET /buchungs/1
  # GET /buchungs/1.json
  def show
  end

  # GET /buchungs/new
  def new
    @buchung = Buchung.new
  end

  # GET /buchungs/1/edit
  def edit
  end

  # POST /buchungs
  # POST /buchungs.json
  def create
    buch_params = buchung_params

    jahr = buch_params['start(1i)']
    monat = buch_params['start(2i)']
    tag = buch_params['start(3i)']
    stunde = buch_params['start(4i)']
    minuten = nil
    ende_uhrzeit = buch_params['ende']

    start_buchung = Time.mktime(jahr, monat, tag, stunde)
    ende_buchung = Time.mktime(jahr, monat, tag, ende_uhrzeit)

    @buchung = Buchung.new(buchung_params)
    @buchung.start = start_buchung
    @buchung.ende = ende_buchung


    respond_to do |format|
      if @buchung.save
        format.html { redirect_to @buchung, notice: 'Buchung was successfully created.' }
        format.json { render :show, status: :created, location: @buchung }
      else
        format.html { render :new }
        format.json { render json: @buchung.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buchungs/1
  # PATCH/PUT /buchungs/1.json
  def update
    respond_to do |format|
      if @buchung.update(buchung_params)
        format.html { redirect_to @buchung, notice: 'Buchung was successfully updated.' }
        format.json { render :show, status: :ok, location: @buchung }
      else
        format.html { render :edit }
        format.json { render json: @buchung.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buchungs/1
  # DELETE /buchungs/1.json
  def destroy
    @buchung.destroy
    respond_to do |format|
      format.html { redirect_to buchungs_url, notice: 'Buchung was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_buchung
    @buchung = Buchung.find(params[:id])
  end

  def set_verfugbarkeits
    @verfugbarkeits = Verfugbarkeit.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def buchung_params
    params.require(:buchung).permit(:status, :start, :ende, :typ)
  end
end
