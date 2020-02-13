require 'rails_helper'

RSpec.describe "Posts", type: :system do
  fixtures(:posts, :users)

  def sign_in(user, password='password')
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_on 'Log in'
  end

  describe 'creating a post' do
    it 'requires a logged in user' do
      visit '/'
      click_on 'New Post'
      expect(page).to have_content('You need to sign in or sign up before continuing')
      sign_in(users(:dhh))
      expect(page).to have_current_path(new_post_path)
    end

    it 'creates a post at the top of the index' do
      visit '/'
      click_on 'New Post'
      sign_in(users(:dhh))

      title = 'A Whole New Post'
      body = 'These posts are brand new straight from the factory floor. You won’t find a better post anywhere!'
      fill_in 'Title', with: title
      fill_in 'Body', with: body
      click_on 'Create'

      expect(page).to have_content('Post created successfully')
      expect(page).to have_content(title)
      expect(page).to have_content(body)

      visit '/'

      expect(page).to have_content(title)
      click_on title
      expect(page).to have_content(body)
    end

    it 'validates the post fields' do
      visit new_post_path
      sign_in(users(:dhh))

      click_on 'Create'
      title = 'A Whole New Post'
      body = 'These posts are brand new straight from the factory floor. You won’t find a better post anywhere!'

      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content("Body can't be blank")

      fill_in 'Title', with: title
      click_on 'Create'

      expect(page).to_not have_content("Title can't be blank")
      expect(page).to have_content("Body can't be blank")

      fill_in 'Body', with: body
      click_on 'Create'

      expect(page).to_not have_content("Title can't be blank")
      expect(page).to_not have_content("Body can't be blank")
      expect(page).to have_content('Post created successfully')
    end
  end

  describe 'index' do
    it 'shows the most recent posts' do
      visit '/'
      expect(page).to have_content('Welcome to the Porcupine Post')

      expect(page).to have_content('Node is awesome')
      expect(page).to have_content('by RYAN DAHL')

      expect(page).to have_content('Spring Boot is cooler')
      expect(page).to have_content('by RYAN DAHL')

      expect(page).to have_content('Go is faster')
      expect(page).to have_content('by ROB PIKE')

      expect(page).to have_content("'What about me?' -Rails")
      expect(page).to have_content('by DHH')
    end

    it 'paginates ten posts per page' do
      visit '/'
      expect(all('.post-card').length).to eq(10)
    end

    it 'links to the whole post' do
      visit '/'
      click_link 'Go is faster'
      post = posts(:go)
      expect(page).to have_content(post.title)
      expect(page).to have_content(post.body)
    end
  end

  describe 'editing a post' do
    it 'edits a post' do
      post = posts(:rails)
      new_title = 'Rails is Nice'
      new_body = 'Rails likes things that are active and action-y.'

      visit post_path(post)
      click_link 'Edit'
      sign_in(users(:dhh))
      fill_in 'Title', with: new_title
      fill_in 'Body', with: new_body
      click_on 'Save'

      expect(page).to have_current_path(post_path(post))
      expect(page).to have_content('Post updated successfully')
      expect(page).to have_content(new_title)
      expect(page).to have_content(new_body)
    end
  end

  describe 'deleting a post' do
    it 'deletes a post' do
      post = posts(:rails)
      title = post.title

      visit '/'
      expect(page).to have_content(title)

      visit new_user_session_path
      sign_in(users(:dhh))

      visit post_path(post)
      click_on 'Delete'

      expect(page).to have_current_path(root_path)
      expect(page).to have_content('Post deleted successfully')
      expect(page).to_not have_content(post.title)
    end
  end

  describe 'viewing a user’s posts' do
    it 'shows a list of a user’s posts' do
      user = users(:robot)
      visit '/'
      within(first('.post-card', text: user.name.upcase)) do
        click_on user.name
      end

      expect(page).to have_current_path(user_path(user))
      expect(page).to_not have_content(users(:dhh).name.upcase)
      most_recent_post = user.posts.order(:created_at).last
      click_on most_recent_post.title
      expect(page).to have_current_path(post_path(most_recent_post))
    end
  end
end
