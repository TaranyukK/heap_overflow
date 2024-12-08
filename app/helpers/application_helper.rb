module ApplicationHelper
  def flash_messages
    alert_types = {
      notice:  'success',
      alert:   'danger',
      error:   'danger',
      warning: 'warning',
      info:    'info'
    }

    flash.map do |type, message|
      content_tag(:div, message.html_safe, class: "alert alert-#{alert_types[type.to_sym]}")
    end.join.html_safe
  end

  def item_link(item)
    case item
    when Question
      link_to item.title, question_path(item)
    when Answer
      link_to item.body, question_path(item.question)
    when Comment
      link_to item.body, find_comment_path(item)
    when User
      link_to item.email, user_path(item)
    else
      root_path
    end
  end

  private

  def find_comment_path(comment)
    if comment.commentable.is_a?(Question)
      question_path(comment.commentable)
    else
      question_path(comment.commentable.question)
    end
  end
end
