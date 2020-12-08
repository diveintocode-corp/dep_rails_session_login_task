require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe 'タスク関連画面' do
    let!(:user){FactoryBot.create(:user)}
    let!(:task){FactoryBot.create(:task, user_id: user.id)}
    context '未ログインの状態でタスク一覧画面にアクセスした場合' do
      it 'ログイン画面に遷移する' do
        visit tasks_path
        expect(current_path).to eq new_session_path
      end
    end
    context '未ログインの状態でタスク編集画面にアクセスした場合' do
      it 'ログイン画面に遷移する' do
        visit edit_task_path(task)
        expect(current_path).to eq new_session_path
      end
    end
    context '未ログインの状態でタスク詳細画面にアクセスした場合' do
      it 'ログイン画面に遷移する' do
        visit task_path(task)
        expect(current_path).to eq new_session_path
      end
    end
    context '未ログインの状態でタスク作成画面にアクセスした場合' do
      it 'ログイン画面に遷移する' do
        visit new_task_path
        expect(current_path).to eq new_session_path
      end
    end
  end
end
