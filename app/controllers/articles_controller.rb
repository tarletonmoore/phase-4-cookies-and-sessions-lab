class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    cookies[:page_views] ||= 0
    cookies[:page_views] = cookies[:page_views].to_i + 1
    session[:page_views] ||= 0
    session[:page_views] += 1
    article = Article.find(params[:id])
    if cookies[:page_views] > 3
      limit_reached
    else
    render json: article
    end
  end



  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def limit_reached
    render json: { error: "Maximum pageview limit reached"}, status: :unauthorized
  end

end
