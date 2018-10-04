require 'rails_helper'

describe 'post_path' do
  before do
    @author = Author.create(name: 'Cormac McCarthy')
    @post = Post.create(title: 'My Post', description: 'My post desc', author: @author)
  end

  it 'responds correctly' do
    visit post_path(@post)
    expect(page.status_code).to eq(200), 'post_path is not responding correctly'
  end

  it 'shows the appropriate post information' do
    visit post_path(@post)
    expect(page).to have_css('h1', text: 'My Post'), 'show.html is not rendering correct content'
  end
end

describe 'post_controller' do
  before do
    @author = Author.create(name: 'Cormac McCarthy')
    @post = Post.create(title: 'My Post', description: 'My post desc', author: @author)
  end

  it 'responds to json format request' do
    visit post_path(id: @post.id, format: :json)
    expect(page.status_code).to eq(200)
  end

  it 'returns appropriate json content' do
    visit post_path(id: @post.id, format: :json)
    expect(page.html).not_to include('<!DOCTYPE html>'), 'expected JSON to be returned, got HTML instead'
    expect(JSON.parse(page.html)).to eq('author' => { 'name' => 'Cormac McCarthy' }, 'description' => 'My post desc', 'id' => 1, 'title' => 'My Post'), 'returned JSON does not match expected format/may be have incorrect content'
  end
end
