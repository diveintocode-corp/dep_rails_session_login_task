require 'rails_helper'

RSpec.describe do
  describe '1.ユーザ登録した際、タスク一覧画面に遷移させ、"アカウントを登録しました。"というフラッシュメッセージを表示させること' do
    it 'ユーザ登録した際、タスク一覧画面に遷移させること' do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      find('input[type="submit"]').click
      expect(current_path).to eq tasks_path
    end
    it 'ユーザ登録した際、"アカウントを登録しました。"というフラッシュメッセージを表示させること' do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      find('input[type="submit"]').click
      expect(page).to have_content 'アカウントを登録しました。'
    end
  end
  describe '2.ログインした際、タスクの一覧画面に遷移させ、"ログインしました。"というフラッシュメッセージを表示させること' do
    let!(:user){FactoryBot.create(:user)}
    it 'ログインした際、タスクの一覧画面に遷移させること' do
      visit new_session_path
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      find('input[type="submit"]').click
      expect(current_path).to eq tasks_path
    end
    it 'ログインした際、"ログインしました。"というフラッシュメッセージを表示させること' do
      visit new_session_path
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      find('input[type="submit"]').click
      expect(page).to have_content 'ログインしました。'
    end
  end
  describe '3.ログインに失敗した場合、renderを使ってログイン画面を表示させ、"メールアドレスまたはパスワードが間違っています。"というフラッシュメッセージを表示させること' do
    let!(:user){FactoryBot.create(:user)}
    it 'ログインに失敗した場合、renderを使ってログイン画面を表示させること' do
      visit new_session_path
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: "pasword"
      find('input[type="submit"]').click
      expect(current_path).to eq sessions_path
    end
    it 'ログインに失敗した場合、"メールアドレスまたはパスワードが間違っています。"というフラッシュメッセージを表示させること' do
      visit new_session_path
      fill_in 'session_email', with: "user@gmail.co"
      fill_in 'session_password', with: user.password
      find('input[type="submit"]').click
      expect(page).to have_content 'メールアドレスまたはパスワードが間違っています。'
    end
  end
  describe '4.ログアウトした際、ログイン画面に遷移させ、"ログアウトしました。"というフラッシュメッセージを表示させること' do
    let!(:user){FactoryBot.create(:user)}
    before do
      visit new_session_path
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      find('input[type="submit"]').click
    end
    it 'ログアウトした際、ログイン画面に遷移させること' do
      click_link nil, href: session_path(user.id)
      expect(current_path).to eq new_session_path
    end
    it 'ログアウトした際、"ログアウトしました。"というフラッシュメッセージを表示させること' do
      click_link nil, href: session_path(user.id)
      expect(page).to have_content 'ログアウトしました。'
    end
  end
  describe '5.未ログインの場合は「ログイン画面へのリンク」と「ユーザ登録画面へのリンク」のみ表示させること' do
    let!(:user){FactoryBot.create(:user)}
    before do
      visit new_session_path
    end
    it '未ログインの場合、「ログイン画面へのリンク」が表示させること' do
      expect(page).to have_link href: new_session_path
    end
    it '未ログインの場合、「ユーザ登録画面へのリンク」が表示させること' do
      expect(page).to have_link href: new_user_path
    end
    it '未ログインの場合は「ログアウトのリンク」が表示されないこと' do
      expect(page).not_to have_link href: session_path(user.id)
    end
  end
  describe '6.ログイン済みの場合は「ログアウトのリンク」のみ表示させること' do
    let!(:user){FactoryBot.create(:user)}
    before do
      visit new_session_path
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      find('input[type="submit"]').click
    end
    it '未ログインの場合、「ログイン画面へのリンク」が表示させること' do
      expect(page).not_to have_link href: new_session_path
    end
    it '未ログインの場合、「ユーザ登録画面へのリンク」が表示させること' do
      expect(page).not_to have_link href: new_user_path
    end
    it '未ログインの場合は「ログアウトのリンク」が表示されないこと' do
      expect(page).to have_link href: session_path(user.id)
    end
  end
  describe '7.ユーザ登録すると同時にログインさせること' do
    it 'ユーザ登録すると同時にログインさせること' do
      visit new_user_path
      fill_in 'user_name', with: 'user_name'
      fill_in 'user_email', with: 'user@gmail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      find('input[type="submit"]').click
      user = User.take
      expect(current_path).to eq tasks_path
      expect(page).to have_link href: session_path(user.id)
      expect(page).to have_content 'アカウントを登録しました。'
    end
  end
  describe '8.ログインをせずにログイン画面とユーザ登録画面以外にアクセスした場合、ログイン画面に遷移させること
' do
    let!(:user){FactoryBot.create(:user)}
    let!(:task){FactoryBot.create(:task, user_id: user.id)}
    it 'ログインをせずにログイン画面にアクセスした場合、ログイン画面に遷移する' do
      visit new_session_path
      expect(current_path).to eq new_session_path
    end
    it 'ログインをせずにユーザ登録画面にアクセスした場合、ユーザ登録画面に遷移する' do
      visit new_user_path
      expect(current_path).to eq new_user_path
    end
    it 'ログインをせずにタスク一覧画面にアクセスした場合、ログイン画面に遷移する' do
      visit tasks_path
      expect(current_path).to eq new_session_path
    end
    it 'ログインをせずにタスク登録画面にアクセスした場合、ログイン画面に遷移する' do
      visit new_task_path
      expect(current_path).to eq new_session_path
    end
    it 'ログインをせずにタスク編集画面にアクセスした場合、ログイン画面に遷移する' do
      visit edit_task_path(task.id)
      expect(current_path).to eq new_session_path
    end
    it 'ログインをせずにタスク詳細画面にアクセスした場合、ログイン画面に遷移する' do
      visit task_path(task.id)
      expect(current_path).to eq new_session_path
    end
  end
end
