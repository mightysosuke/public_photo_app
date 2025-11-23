# README

## 実行するコマンド

### サーバーを起動するまでの準備
```bash

# gemのインストール
$ bundle install
# データベースのマイグレーション
$ rails db:migrate
```

### サーバーの起動
```bash
# railsサーバーの起動
$ bin/rails server
```
`http://localhost:3000`に接続することで、ログイン画面が表示されます。

### テストの実行
```bash
$ bundle exec rspec
```
