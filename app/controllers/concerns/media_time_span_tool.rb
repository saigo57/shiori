# frozen_string_literal: true

module MediaTimeSpanTool
  extend ActiveSupport::Concern

  # 一つ前の状態に戻れる状態で、next_spansを適用する
  def forward_spans(next_spans)
    MediaTimeSpan.transaction do
      next_seq_id = @media_manage.curr_seq_id + 1
      prev_seq_id = @media_manage.curr_seq_id - 1

      import_list = next_spans.map do |span|
        @media_manage.time_spans.create({ seq_id: next_seq_id, **span })
      end

      MediaTimeSpan.import %w[begin_sec end_sec seq_id], import_list
      @media_manage.update(curr_seq_id: next_seq_id)
      @media_manage.media_time_span.where(seq_id: prev_seq_id).destroy_all
    end
  end

  # 重なっている時間をマージする
  def merge_spans(spans)
    sorted_spans = sort_spans(spans)
    merged_list = [sorted_spans.first]
    sorted_spans[1..].each do |span|
      if merged_list.last[:end_sec] < span[:begin_sec]
        merged_list.append(span)
      elsif merged_list.last[:end_sec] < span[:end_sec]
        merged_list.last[:end_sec] = span[:end_sec]
      end
    end
    merged_list
  end

  # spansをソート
  def sort_spans(spans)
    spans.sort do |a, b|
      if a[:begin_sec] == b[:begin_sec]
        a[:end_sec] <=> b[:end_sec]
      else
        a[:begin_sec] <=> b[:begin_sec]
      end
    end
  end
end
