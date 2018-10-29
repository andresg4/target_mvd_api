require 'rails_helper'

describe 'GET api/v1/targets', type: :request do
  include_examples 'index examples', 'targets', 'target', '/api/v1/targets'
  include_examples 'invalid headers get', '/api/v1/targets'
end
