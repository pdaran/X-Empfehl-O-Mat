# frozen_string_literal: true
<<<<<<< HEAD

=======
>>>>>>> 2b9d3cf (🎨  rubocop lint, ignore style/docs check)
class CommentsController < ApplicationController
  http_basic_authenticate_with name: 'dhh', password: 'secret', only: :destroy

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

<<<<<<< HEAD
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private

=======
  http_basic_authenticate_with name: 'dhh', password: 'secret', only: :destroy

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private

>>>>>>> 2b9d3cf (🎨  rubocop lint, ignore style/docs check)
  def comment_params
    params.require(:comment).permit(:commenter, :body, :status)
  end
end
