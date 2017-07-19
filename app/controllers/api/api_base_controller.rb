class Api::ApiBaseController < ApplicationController

  before_action :set_lang # TODO: check auth key before every request

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
