require 'spec_helper'

describe 'routing for questions', :type => :routing do
  it 'routes / to questions#index' do
    expect({ get: '/' }).to route_to(controller: 'questions', action: 'index')
    expect({ get: '/questions' }).not_to be_routable
  end

  it 'routes /ask to questions#new' do
    expect({ get: '/ask' }).to route_to(controller: 'questions', action: 'new')
  end

  it 'routes post /questions to questions#create' do
    expect({ post: '/questions' }).to route_to(controller: 'questions', action: 'create')
  end

  it 'routes get /q/:id/edit to questions#edit' do
    expect({ get: '/q/1/edit' }).to route_to(controller: 'questions', action: 'edit', id: '1')
  end
end
