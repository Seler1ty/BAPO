class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_article, only: [ :show, :update, :destroy ]

  def index
    articles = Article.includes(:user, :tags).recent
    articles = articles.by_author(params[:author]) if params[:author]
    articles = articles.by_tag(params[:tag]) if params[:tag]
    render json: { articles: articles.map { |a| serialize_article(a) } }
  end

  def show
    render json: { article: serialize_article(@article) }
  end

  def create
    article = current_user.articles.build(article_params)
    sync_tags(article, params[:tags])
    article.save!
    render json: { article: serialize_article(article) }, status: :created
  end

  def update
    return unless owner?
    @article.update!(article_params)
    sync_tags(@article, params[:tags])
    render json: { article: serialize_article(@article) }
  end

  def destroy
    return unless owner?
    @article.destroy
    head :no_content
  end

  private

  def set_article
    @article = Article.find_by!(slug: params[:slug] || params[:id])
  end

  def owner?
    return true if @article.user == current_user
    render json: { error: "Not authorized" }, status: :forbidden
    false
  end

  def article_params
    params.require(:article).permit(:title, :description, :body)
  end

  def sync_tags(article, tag_names)
    return unless tag_names.present?
    article.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
  end

  def serialize_article(article)
    {
      id: article.id,
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tags: article.tags.pluck(:name),
      author: article.user.as_json(only: [ :username, :bio, :image ]),
      created_at: article.created_at,
      updated_at: article.updated_at
    }
  end
end
