require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe 'アカウント登録画面' do
    context 'ユーザの登録に成功した場合' do
      before do
        visit new_user_path
        fill_in 'user_name', with: 'sample_user'
        fill_in 'user_email', with: 'user@gmail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        find('input[type="submit"]').click
      end
      it 'タスク一覧画面に遷移する' do
        expect(current_path).to eq tasks_path
      end
      it 'ログアウトリンクが表示される' do
        user = User.take
        expect(page).to have_link href: session_path(user.id)
      end
      it 'ログインリンクは表示されない' do
        expect(page).not_to have_link href: new_session_path
      end
    end
    context 'ユーザの登録に失敗した場合' do
      before do
        visit new_user_path
        fill_in 'user_name', with: 'sample_user'
        fill_in 'user_email', with: 'user@gmail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: ''
        find('input[type="submit"]').click
      end
      it 'アカウント登録画面をレンダーする' do
        expect(current_path).to eq users_path
        expect(find_field("user_name").value).to eq "sample_user"
        expect(find_field("user_email").value).to eq "user@gmail.com"
      end
      it 'ユーザデータは登録されない' do
        expect(User.exists?).to eq false
      end
    end
  end

  describe 'ログイン画面' do
    let!(:user){FactoryBot.create(:user)}
    context 'ログインに成功した場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        find('input[type="submit"]').click
      end
      it 'タスク一覧画面に遷移する' do
        expect(current_path).to eq tasks_path
      end
      it 'ログアウトリンクが表示される' do
        user = User.take
        expect(page).to have_link href: session_path(user.id)
      end
      it 'ログインリンクは表示されない' do
        expect(page).not_to have_link href: new_session_path
      end
    end
    context 'ログインに失敗した場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: ''
        find('input[type="submit"]').click
      end
      it 'アカウント登録画面をレンダーする' do
        expect(current_path).to eq sessions_path
      end
    end
  end
end
