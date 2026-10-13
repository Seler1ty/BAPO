class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  before_action :set_article
  before_action :set_comment, only: [ :destroy ]

  def index
    comments = @article.comments.includes(:user)
    render json: { comments: comments.map { |c| serialize_comment(c) } }
  end

  def create
    comment = @article.comments.build(comment_params)
    comment.user = current_user
    comment.save!
    render json: { comment: serialize_comment(comment) }, status: :created
  end

  def destroy
    unless @comment.user == current_user
      render json: { error: "Not authorized" }, status: :forbidden
      return
    end
    @comment.destroy
    head :no_content
  end

  private

  def set_article
    @article = Article.find_by!(slug: params[:article_slug])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def serialize_comment(comment)
    {
      id: comment.id,
      body: comment.body,
      author: comment.user.as_json(only: [ :username, :bio, :image ]),
      created_at: comment.created_at
    }
  end
end
