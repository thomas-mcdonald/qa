require 'spec_helper'

describe 'routing for questions' do
  it 'routes / to questions#index' do
    { get: '/' }.should route_to(controller: 'questions', action: 'index' )
    { get: '/questions' }.should_not be_routable
  end
end