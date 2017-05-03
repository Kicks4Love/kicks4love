class Admin::OnCourtPostsController < Admin::AdminController
  before_action :get_on_court_post, :only => [:edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:destroy]

  def index
    @page_title = "Kicks4Love Admin | On Court Posts"
		@on_court_posts = OnCourtPost.latest

    if params[:filter].present?
      session[:on_court_post_per_page] = params[:filter][:per_page].to_i
    end
    @per_page = session[:on_court_post_per_page] || 5
    @on_court_posts = @on_court_posts.paginate(:page => params[:page] || 1, :per_page => session[:on_court_post_per_page] || 10)
  end

  # def show
  #
  # end

  def new
    @page_title = "Kicks4Love Admin | Create a new On Court post"
    @new_post = OnCourtPost.new
  end

  def create
    new_post = OnCourtPost.new on_court_post_params
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
    if @on_court_post.update_attributes(on_court_post_params)
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

  private

  def on_court_post_params
    params
    .require(:on_court_post)
    .permit(:title_en, :title_cn, :content_en, :content_cn, :cover_image, :main_image)
  end

  def get_on_court_post
    @on_court_post = OnCourtPost.find_by_id(params[:id])
  end

end