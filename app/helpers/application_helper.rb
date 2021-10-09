# frozen_string_literal: true

module ApplicationHelper
  def add_params_to_url(url, params = {})
    uri = URI.parse(url)
    original_hash = {}
    original_hash = Hash[URI.decode_www_form(uri.query)] if uri.query
    query = original_hash.transform_keys(&:to_sym)
    query = query.merge(params.transform_keys(&:to_sym)) if params
    uri.query = query.to_a.any? ? URI.encode_www_form(query.to_a) : nil
    uri.to_s
  end
end
