class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy]

  # def index
  #   @start_date = params[:start_date]
  #   @end_date = params[:end_date]
  #   # Production.limit(20).includes(:issource, :invoices).order(:iss_source).each do |intermediary|
  #   #   @production = intermediary.policies.search_date(@start_date,@end_date).page(params[:page])
  #   # end
  #   @productions = Production.includes(:issource, :invoices).order(:iss_source).page(params[:page])
  # end

  def index
    detect_date_params
    @productions = Production.distinct.order_by_issue_cd.filter_by_date(@start_date,@end_date).page(params[:page])
  end

  # GET /productions/1
  # GET /productions/1.json
  def show
    detect_date_params
    @product = Production.find(params[:id])
  end

  # GET /productions/new
  def new
    @production = Production.new
  end

  # GET /productions/1/edit
  def edit
  end

  # POST /productions
  # POST /productions.json
  def create
    @production = Production.new(production_params)

    respond_to do |format|
      if @production.save
        format.html { redirect_to @production, notice: 'Production was successfully created.' }
        format.json { render :show, status: :created, location: @production }
      else
        format.html { render :new }
        format.json { render json: @production.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productions/1
  # PATCH/PUT /productions/1.json
  def update
    respond_to do |format|
      if @production.update(production_params)
        format.html { redirect_to @production, notice: 'Production was successfully updated.' }
        format.json { render :show, status: :ok, location: @production }
      else
        format.html { render :edit }
        format.json { render json: @production.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productions/1
  # DELETE /productions/1.json
  def destroy
    @production.destroy
    respond_to do |format|
      format.html { redirect_to productions_url, notice: 'Production was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def detect_date_params
      if params[:start_date].present?
        @start_date = params[:start_date]
        @end_date =  params[:end_date]
      else
        @start_date =  Date.current.beginning_of_month
        @end_date =  Date.current.end_of_month
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_production
      @production = Production.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def production_params
      params.require(:production).permit(:intermediary, :intm_no, :branch)
    end
end
