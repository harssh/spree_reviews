class Spree::Admin::ReviewsController < Spree::Admin::ResourceController
  helper Spree::ReviewsHelper
  helper Spree::BaseHelper
  
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  
  def index
    @reviews = collection
  end

  
  def new
    @review = Spree::Review.new
  end

  def create
    params[:review][:rating].sub!(/\s*[^0-9]*$/,'') unless params[:review][:rating].blank?

    @review = Spree::Review.new(params[:review])
   
    @review.user = spree_current_user if user_signed_in?
    @review.ip_address = request.remote_ip
    @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

    authorize! :create, @review

    if @review.save
      flash[:notice] = t('review_successfully_submitted')
      redirect_to admin_reviews_path
    else
      render :action => "new"
    end
  end

  def destroy
    
    Spree::Review.find_by_id(params[:id]).destroy
    
  end
  


  def approve
    r = Spree::Review.find(params[:id])

    if r.update_attribute(:approved, true)
       flash[:notice] = t("info_approve_review")
    else
       flash[:error] = t("error_approve_review")
    end
    redirect_to admin_reviews_path
  end

  
private

  def collection
    params[:q] ||= {}
    params[:q][:approved_eq] = false if params[:q][:approved_eq].nil?

    @search = Spree::Review.ransack(params[:q])
    @collection = @search.result.includes([:product, :user, :feedback_reviews]).page(params[:page]).per(params[:per_page])
  end
end
