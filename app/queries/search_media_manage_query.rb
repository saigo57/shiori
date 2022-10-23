# frozen_string_literal: true

class SearchMediaManageQuery < Query
  # 文字列で検索する
  def search_text
    pattern = ''
    @keywords.each do |k|
      pattern += "(?=.*#{k})"
    end
    pattern += '.*'

    base_list = MediaManage.list
    base_list.where('media_manages.title REGEXP ?', pattern)
             .or(base_list.where('media_manages.media_url REGEXP ?', pattern))
  end

  # チェックボックスでフィルタリングする
  def filter
    base_list = if @keywords.nil?
                  MediaManage.list
                else
                  search_text
                end

    status_list = []
    MediaManage.statuses.keys.map(&:to_sym).each do |item|
      status_list.append(MediaManage.statuses[item]) if @flags[item]
    end

    base_list.where(status: status_list)
  end

  # ソートする
  def sort
    base_scope = filter
    order = @sort_order

    case @sort_target
    when 'media_time'
      base_scope.order(media_sec: order)
    when 'remaining_time'
      base_scope.order(remaining_sec: order, media_sec: order)
    when 'registration'
      base_scope.order(created_at: order)
    else
      base_scope
    end
  end

  def call(flags, sort_target, sort_order, keywords_text = '')
    @flags = flags
    @sort_target = sort_target
    @sort_order = sort_order
    @keywords = if keywords_text.empty?
                  []
                else
                  keywords_text.split(/[[:blank:]]/)
                end

    sort
  end
end
