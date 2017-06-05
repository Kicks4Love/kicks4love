class Admin::StreetSnapPostsController < Admin::AdminController
  skip_before_filter :verify_authenticity_token, :only => [:destroy]
  before_action :get_street_snap_post, :only => [:edit, :destroy, :update, :show]

  def index
    @page_title = "Street snap Posts | Kicks4Love Admin"
    @street_snap_posts = StreetSnapPost.latest
    @expired_posts_count = StreetSnapPost.old.size;
    if params[:filter].present?
      session[:street_snap_post_per_page] = params[:filter][:per_page].to_i
    end
    @per_page = session[:street_snap_post_per_page] || 5
    @street_snap_posts = @street_snap_posts.paginate(:page => params[:page] || 1, :per_page => session[:street_snap_post_per_page] || 5)
  end

  def new
    @street_snap_post = StreetSnapPost.new
    @page_title = "New Street snap Post | Kicks4Love Admin"
  end

  def create
    street_snap_post = StreetSnapPost.new process_content(street_snap_post_params)

    street_snap_post.author = current_admin_user

    if street_snap_post.content_en.count > StreetSnapPost::MAX_NUMBER_ALLOW || street_snap_post.content_cn.count > StreetSnapPost::MAX_NUMBER_ALLOW 
          redirect_to :back, :alert => "Maximum paragraph number is #{StreetSnapPost::MAX_NUMBER_ALLOW}"
          return
      elsif street_snap_post.main_images.count > StreetSnapPost::MAX_NUMBER_ALLOW 
          redirect_to :back, :alert => "Maximum main image number is #{StreetSnapPost::MAX_NUMBER_ALLOW}"
          return
      end

    if street_snap_post.save
      redirect_to admin_street_snap_posts_path, :notice => "New street snap post successfully created"
    else
      redirect_to :back, :alert => "Error creating new street snap post"
    end
  end

  def update
    params = process_content(street_snap_post_params)

    if params[:content_en].count > StreetSnapPost::MAX_NUMBER_ALLOW  || params[:content_cn].count > StreetSnapPost::MAX_NUMBER_ALLOW 
          redirect_to :back, :alert => "Maximum paragraph number is #{StreetSnapPost::MAX_NUMBER_ALLOW }"
          return
      elsif params[:main_images].present? && params[:main_images].count > StreetSnapPost::MAX_NUMBER_ALLOW 
          redirect_to :back, :alert => "Maximum main image number is #{StreetSnapPost::MAX_NUMBER_ALLOW }"
          return
      end

    @street_snap_post.author = current_admin_user if @street_snap_post.author.nil?

    if @street_snap_post.update_attributes(params)
      flash[:notice] = "The street snap post has been successfully updated"
    else
      flash[:alert] = "Error occurs while updating the street snap post, please try again"
    end

    redirect_to admin_street_snap_posts_path
  end

  def edit
    @page_title = "Edit Street Snap Post | Kicks4Love Admin"
  end

  def destroy
    if @street_snap_post.destroy
      flash[:notice] = "The street snap post has been deleted successfully"
    else
      flash[:alert] = "Error occurs while deleting the street snap post, please try again"
    end

    redirect_to admin_street_snap_posts_path
  end

  def remove_old
    old_posts = StreetSnapPost.old
    return_posts = old_posts.to_a
    if old_posts.delete_all
      render :json => return_posts.to_json, :layout => false
    else
      head :ok, :status => 500
    end
  end

  private

  def street_snap_post_params
    params
    .require(:street_snap_post)
    .permit(:title_en, :title_cn, :content_en, :content_cn, :cover_image, {main_images: []}, :remove_main_images, :post_composition)
  end

  def process_content(params)
    params[:content_en] = params[:content_en].split(/\r?\n/)
    params[:content_cn] = params[:content_cn].split(/\r?\n/)
    params[:post_composition] = JSON.parse params[:post_composition]
      return params
    end

  def get_street_snap_post
    @street_snap_post = StreetSnapPost.find_by_id(params[:id])
  end

end