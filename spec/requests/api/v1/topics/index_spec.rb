require 'rails_helper'

describe 'GET api/v1/topics', type: :request do
  include_examples 'index examples', 'topics', 'topic', '/api/v1/topics'
  include_examples 'invalid headers get', '/api/v1/topics'
end
