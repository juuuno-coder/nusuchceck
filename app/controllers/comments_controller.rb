# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post, anchor: "comment-#{@comment.id}"), notice: "댓글이 등록되었습니다."
    else
      redirect_to post_path(@post), alert: @comment.errors.full_messages.join(", ")
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    unless @comment.user == current_user || current_user.admin?
      redirect_to post_path(@post), alert: "권한이 없습니다."
      return
    end

    @comment.destroy
    redirect_to post_path(@post), notice: "댓글이 삭제되었습니다."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
