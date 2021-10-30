# frozen_string_literal: true

require 'grape'

class API < Grape::API
  # urlの第１セグメント名 ex) http://localhost/api/
  prefix 'api'
  format :json
  # app/api/resources/v1/root.rbをマウント
  mount Resources::V1::Root
end
