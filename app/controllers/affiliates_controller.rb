class AffiliatesController < ApplicationController
  include CommonModule
  before_action :set_affiliate, only: [:show, :edit, :update, :destroy]

  def index
    if check_role(current_user)
      @affiliates = Affiliate.all
    end
  end

  def show
    check_role(current_user)
  end


  def new
    if check_role(current_user)
      @affiliate = Affiliate.new
    end
  end

  def edit
    check_role(current_user)
  end

  def create
    if check_role(current_user)
      @affiliate = Affiliate.new(affiliate_params)

      respond_to do |format|
        if @affiliate.save
          format.html { redirect_to @affiliate, notice: 'Affiliate was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    if check_role(current_user)
      respond_to do |format|
        if @affiliate.update(affiliate_params)
          format.html { redirect_to @affiliate, notice: 'Affiliate was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    if check_role(current_user)
      @affiliate.destroy
      respond_to do |format|
        format.html { redirect_to affiliates_url, notice: 'Affiliate was successfully destroyed.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_affiliate
      @affiliate = Affiliate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def affiliate_params
      params.require(:affiliate).permit(:company, :a_id, :a_tag, :delete_flg)
    end
end
