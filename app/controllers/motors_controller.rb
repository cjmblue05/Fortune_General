require 'will_paginate'
class MotorsController < ApplicationController
  before_action :set_motor, only: [:show, :edit, :update, :destroy]

  # GET /motors
  # GET /Policy.json
  def index
    start_date = params[:start_date]
    end_date = params[:end_date]

    @motor_policies = Policy.motor_search(start_date, end_date, params[:page])
    @claims = Claim.claim_search(start_date, end_date, params[:page])
   @motor_policies_csv = Policy.where(acct_ent_date: start_date..end_date).where(line_code: "MC").or(Policy.where(spld_acct_ent_date: start_date..end_date)).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body)

    respond_to do |format|
    format.html
    format.csv { send_data @motor_policies_csv.to_csv1(start_date,end_date), filename: "motorcar-#{start_date} / #{end_date}.csv" }
    format.xls
    format.pdf do
       pdf = MotorsReport.new(@motor_policies, start_date, end_date)
       send_data pdf.render,filename: "MotorCar.pdf",
                           type: "application/pdf"
                           # ,
                           # disposition: "inline"
     end
   end
  end

  # GET /motors/1
  # GET /motors/1.json
  def show
  end

  # GET /motors/new
  def new
    @motors = Policy.new
  end

  # GET /motors/1/edit
  def edit
  end

  # POST /motors
  # POST /Policy.json
  def create
    @motors = Policy.new(motor_params)

    respond_to do |format|
      if @Policy.save
        format.html { redirect_to @motors, notice: 'Motor was successfully created.' }
        format.json { render :show, status: :created, location: @motors }
      else
        format.html { render :new }
        format.json { render json: @Policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /motors/1
  # PATCH/PUT /motors/1.json
  def update
    respond_to do |format|
      if @Policy.update(motor_params)
        format.html { redirect_to @motors, notice: 'Motor was successfully updated.' }
        format.json { render :show, status: :ok, location: @motors }
      else
        format.html { render :edit }
        format.json { render json: @Policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motors/1
  # DELETE /motors/1.json
  def destroy
    @Policy.destroy
    respond_to do |format|
      format.html { redirect_to motors_url, notice: 'motors was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motor
      @motors = Policy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def motor_params
      params.fetch(:policies, {})
    end
end
