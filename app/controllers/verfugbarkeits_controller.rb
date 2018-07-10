class VerfugbarkeitsController < ApplicationController
  before_action :set_verfugbarkeit, only: [:show, :edit, :update, :destroy]

  # GET /verfugbarkeits
  # GET /verfugbarkeits.json
  def index
    @verfugbarkeits = Verfugbarkeit.all
  end

  # GET /verfugbarkeits/1
  # GET /verfugbarkeits/1.json
  def show
  end

  # GET /verfugbarkeits/new
  def new
    @verfugbarkeit = Verfugbarkeit.new
  end

  # GET /verfugbarkeits/1/edit
  def edit
  end

  # POST /verfugbarkeits
  # POST /verfugbarkeits.json
  def create
    @verfugbarkeit = Verfugbarkeit.new(verfugbarkeit_params)

    respond_to do |format|
      if @verfugbarkeit.save
        format.html { redirect_to @verfugbarkeit, notice: 'Verfugbarkeit was successfully created.' }
        format.json { render :show, status: :created, location: @verfugbarkeit }
      else
        format.html { render :new }
        format.json { render json: @verfugbarkeit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /verfugbarkeits/1
  # PATCH/PUT /verfugbarkeits/1.json
  def update
    respond_to do |format|
      if @verfugbarkeit.update(verfugbarkeit_params)
        format.html { redirect_to @verfugbarkeit, notice: 'Verfugbarkeit was successfully updated.' }
        format.json { render :show, status: :ok, location: @verfugbarkeit }
      else
        format.html { render :edit }
        format.json { render json: @verfugbarkeit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /verfugbarkeits/1
  # DELETE /verfugbarkeits/1.json
  def destroy
    @verfugbarkeit.destroy
    respond_to do |format|
      format.html { redirect_to verfugbarkeits_url, notice: 'Verfugbarkeit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_verfugbarkeit
      @verfugbarkeit = Verfugbarkeit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def verfugbarkeit_params
      params.require(:verfugbarkeit).permit(:tag)
    end
end
