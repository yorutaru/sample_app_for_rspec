require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  describe 'ログイン前' do
    before do
      user = create(:user, email: 'a@example.com')
      visit login_path
    end
    
    context 'フォームの入力値が正常' do
      before do
        fill_in 'email', with: 'a@example.com'
        fill_in 'password', with: 'password'
        click_button 'Login'
      end
      it 'ログイン処理が成功する' do
        expect(page).to have_content 'Login successful'
      end
    end
    
    context 'フォームが未入力' do
      before do
        fill_in 'email', with: nil
        fill_in 'password', with: nil
        click_button 'Login'
      end
      it 'ログイン処理が失敗する' do
        expect(page). to have_content 'Login failed'
      end
    end
  end

  describe 'ログイン後' do
    before do
      user = create(:user, email: 'a@example.com')
      visit login_path
      fill_in 'email', with: 'a@example.com'
      fill_in 'password', with: 'password'
      click_button 'Login'
    end
    context 'ログアウトボタンをクリック' do
      before do
        visit tasks_path
        click_on 'Logout'
      end
      it 'ログアウト処理が成功する' do
        expect(page).to have_content 'Logged out'
      end
    end
  end   
end
