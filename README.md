# README

## Bookmark List

### 概要
- ブックマークを管理するアプリケーション

### URL・テストアカウント
- https://bookmark-list.onrender.com

- メールアドレス：test1@example.com

- パスワード：password

### トップ画像
![トップ画像](/doc/BookmarkList_トップ画像.png)

### 機能
- ユーザー管理機能
  - 「devise」を用いたユーザー管理をしています。

- ブックマーク一覧表示機能
  - 「Vue.Draggable」を使用し、ドラッグ＆ドロップで表示の並び替えができます。
  - 「kaminari」を使用し、10件以上ブックマークがある場合はページネーションをしています。
  - ブックマークに登録したURLへ遷移することができます。

- ブックマーク新規投稿機能
  - 「ブックマークを追加する」ボタンで、追加用のモーダルが開き、フォームが表示されます。

- ブックマーク更新機能
  - 各ブックマークのペンのアイコンから、編集用のモーダルが開きます。

- ブックマーク削除機能
  - 各ブックマークのゴミ箱のアイコンから、削除用のモーダルが開きます。

- 検索・カテゴリー絞り込み機能
  - トップページの左上のフォームから、ブックマークの検索、カテゴリー絞り込みができます。

### 使用技術
- Ruby 2.6.10
- Ruby on Rails 6.0.4
- Vue.js 2.6.14
- Vuetify 2.6.2
- MySQL 8.0
- Docker/Docker-compose
- Render

### ER図
![ER図](/doc/erd.png)