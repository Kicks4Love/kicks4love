class Admin::OnCourtPostsController < Admin::AdminController
  before_action :get_on_court_post, :only => [:edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:destroy]

  def index
    @page_title = "Kicks4Love Admin | On Court Posts"
		@on_court_posts = OnCourtPost.latest
    @expired_posts_count = OnCourtPost.old.size;
    if params[:filter].present?
      session[:on_court_post_per_page] = params[:filter][:per_page].to_i
    end
    @per_page = session[:on_court_post_per_page] || 5
    @on_court_posts = @on_court_posts.paginate(:page => params[:page] || 1, :per_page => session[:on_court_post_per_page] || 10)
  end

  def new
    @page_title = "Kicks4Love Admin | Create a new On Court post"
    @on_court_post = OnCourtPost.new
  end

  def create
    new_post = OnCourtPost.new process_content(on_court_post_params)

    if new_post.content_en.count > 2 || new_post.content_cn.count > 2
      redirect_to :back, :alert => "Maximum paragraph number is 2"
      return
    elsif new_post.main_images.count > 2
      redirect_to :back, :alert => "Maximum main image number is 2"
      return
    end

    if new_post.save
      redirect_to admin_on_court_posts_path, :notice => "New On Court post successfully created"
    else
      redirect_to :back, :alert => "Error creating new on court post"
    end
  end

  def edit
    @page_title = "Kicks4Love Admin | Edit a On Court post"
  end

  def update
    params = process_content(on_court_post_params)

    if params[:content_en].count > 2 || params[:content_cn].count > 2
      redirect_to :back, :alert => "Maximum paragraph number is 2"
      return
    elsif params[:main_images].present? && params[:main_images].count > 2
      redirect_to :back, :alert => "Maximum main image number is 2"
      return
    end

    if @on_court_post.update_attributes(params)
      flash[:notice] = "The on court post has been successfully updated"
		else
			flash[:alert] = "Error occurs while updating the on court post, please try again"
    end
    redirect_to admin_on_court_posts_path
  end

  def destroy
    if @on_court_post.destroy
      flash[:notice] = "successfully deleted on court post"
    else
      flash[:alert] = "Something went wrong when deleting the post, please try again"
    end
    redirect_to admin_on_court_posts_path
  end

  def remove_old
    old_posts = OnCourtPost.old
		return_posts = old_posts.to_a
		if old_posts.delete_all
			render :json => return_posts.to_json, :layout => false
		else
			head :ok, :status => 500
		end
  end

  private

  def on_court_post_params
    params
    .require(:on_court_post)
    .permit(:title_en, :title_cn, :content_en, :content_cn, :player_name_en, :player_name_cn, :cover_image, {main_images: []})
  end

  def process_content(params)
		content_en = params[:content_en]
		params[:content_en] = content_en.split(/\r?\n/)
		content_cn = params[:content_cn]
		params[:content_cn] = content_cn.split(/\r?\n/)
    return params
  end

  def get_on_court_post
    @on_court_post = OnCourtPost.find_by_id(params[:id])
  end

end