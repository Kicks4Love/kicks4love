class Api::ApiBaseController < ApplicationController

  protect_from_forgery with: :null_session
  before_action :set_lang, :authenticate_request

  VALID_POST_TYPES =
  ['FeaturePost', 'OnCourtPost', 'TrendPost', 'StreetSnapPost', 'RumorPost']


  def rate
    score = count = 0
    if params[:post_type].present? && VALID_POST_TYPES.include?(params[:post_type]) && params[:id].present?
      begin
        post = params[:post_type].constantize.find_by_id(params[:id])
        rate = Rate.create(:score => params[:score].to_i)
        post.rates << rate
        post.save
        score = post.rates.average(:score).round
        count = post.rates.count
        render :json => { :score => score, :count => count }.to_json, :status => :ok
      rescue => error
        render :json => { :message => error.message }.to_json, :status => 400
      end

    else
      render :json => { :message => 'argument not right' }.to_json, :status => 422
    end

  end

  def search
    query = {
      query: {
        multi_match: {
          query: params[:q].present? ? params[:q].strip : '*',
          type:  'best_fields',
          fields: ['title_en^10', 'title_cn^10', 'content_cn', 'content_en']
        }
      }
    }
    results = Elasticsearch::Model
      .search(query, [FeaturePost, OnCourtPost, TrendPost, CalendarPost, StreetSnapPost, RumorPost])
      .page(params[:page] || 1)
      .per_page(10)
      .records
    no_more = results.current_page >= results.total_pages
    render json: { no_more: no_more, results: Api::ApiHelper.reformat_search_results(results, root_url.chop) }.to_json, status: :ok

  end

  private
  def set_lang
    @chinese = params[:l] == 'cn'
  end

  def authenticate_request
    check_key || render_error
  end

  def render_error
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { message: 'API key required' }.to_json, status: :unauthorized
  end

  def check_key
    authenticate_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end

end
