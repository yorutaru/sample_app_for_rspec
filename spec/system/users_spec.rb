require 'rails_helper'

RSpec.describe "Users", type: :system do

  
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before do
        visit sign_up_path
      end

      context 'タスクの新規作成' do
        before do
          visit new_task_path
        end
        it 'ログイン前にタスクページへのアクセスが失敗する' do
          expect(page).to have_content 'Login required'
        end
      end
    
      context 'フォームの入力値が正常' do
        before do
          fill_in 'Email', with: 'a@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button "SignUp"
        end
        it 'ユーザーの新規作成が成功する' do 
          expect(page).to have_content 'User was successfully created.'
          expect(current_path).to eq login_path 
        end
        
      end

      context 'メールアドレスが未入力' do
        before do
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button "SignUp"
        end
        it 'ユーザーの新規作成が失敗する' do 
          expect(page).to have_content 'User creation failed'
        end
      end

      context '登録済のメールアドレスを使用' do
        before do
          create(:user, email: 'a@example.com')
          fill_in 'Email', with: 'a@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button "SignUp"
        end

        it 'ユーザーの新規作成が失敗する' do
          expect(page).to have_content 'User creation failed'
        end
      end
    end
  end


  describe 'ログイン後' do
    let(:user) { create(:user, email: 'a@example.com') }
      before do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: 'password'
        click_button 'Login'
      end

      describe 'ユーザー編集' do
        before do
          visit edit_user_path(user)
        end

        context 'フォームの入力値が正常' do
          before do
            fill_in 'Email', with: 'edit@example.com'
            fill_in 'Password', with: 'editpassword'
            fill_in 'Password confirmation', with: 'editpassword'
            click_button 'Update'
          end
          it 'ユーザーの編集が成功する' do
            expect(page).to have_content 'User was successfully updated.'
          end
        end

        context 'メールアドレスが未入力' do
          before do
            fill_in 'Email', with: nil
            fill_in 'Password', with: 'editpassword'
            fill_in 'Password confirmation', with: 'editpassword'
            click_button 'Update'
          end
          it 'ユーザーの編集が失敗する' do
            expect(page).to have_content("Email can't be blank")
          end
        end

        #context '登録済みのメールアドレスを使用' do
          #before do
            #fill_in 'Email', with: user.email
            #click_button 'Update'
          #end

          #it 'ユーザーの編集が失敗する' do
            #expect(page). to have_content("has already been taken")
          #end
        #end

        context '他ユーザーの編集ページにアクセス' do
          let(:another_user) { create(:user, email: 'b@example.com') }
          before do
            visit edit_user_path(another_user)
          end
          it '編集ページへのアクセスが失敗する' do
            expect(page).to have_content "Forbidden access"
          end
        end
      end

      describe 'マイページ' do
        before do
          click_on 'New Task'
        end
        context 'タスクを作成' do
          before do
            fill_in 'Title', with: 'テストタイトル'
            fill_in 'Content', with: 'テストコンテント'
            select 'todo', from: 'Status'
            click_button 'Create Task'
          end
          it '新規作成したタスクが表示される' do
            expect(page).to have_content 'テストコンテント'
          end
        end
      end
    end
  end