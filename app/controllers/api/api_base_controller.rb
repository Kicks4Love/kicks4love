class Api::ApiBaseController < ApplicationController

  protect_from_forgery with: :null_session
  before_action :set_lang # TODO: check auth key before every request

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
    query = params[:q].present? ? params[:q].strip : '*'
    query = {
			query: {
                multi_match: {
                    query: params[:q].present? ? params[:q].strip : '*',
                    type:  'best_fields',
                    fields: ['title_en^10', 'title_cn^10', 'content_cn', 'content_en'],
                    operator: 'or',
                    zero_terms_query: 'all'
                }
            }, highlight: { fields: {:'*' => {}} }
        }
    results = Elasticsearch::Model
    .search(
    query,
    [FeaturePost,
      OnCourtPost,
      TrendPost,
      CalendarPost,
      StreetSnapPost,
      RumorPost]).page(params[:page] || 1).per_page(10).results

    no_more = results.total_pages <= results.current_page

    render json: {no_more: no_more, results: Api::ApiHelper.reformat_search_results(results, root_url.chop)}.to_json, status: :ok

  end

  private
  def set_lang
    @chinese = params[:l] == 'cn'
  end

end
