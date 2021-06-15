# このリポジトリについて
Sinatraを使ったシンプルなWebアプリのリポジトリ

# データベースの作成
postgresqlを使用します。

1. <code>psql -U db_name</code>で自分のデータベースにログインする。db_nameには自分のデータベース名を入力してください。

2. <code>postgres=# CREATE DATABASE memos;</code>このアプリ用のデータベース、memosを作成します。

3. <code>\c memos</code>作成したデータベースにログインします。

4. <pre><code>"memos=# CREATE TABLE memos(id TEXT NOT NULL, title TEXT NOT NULL, body TEXT NOT NULL, PRIMARY KEY (id));"
テーブルを作成します。

# ローカルでアプリケーションを立ち上げるための手順
1. <code>git clone -b dev_db https://github.com/Nabegon/sinatra.git</code> を実行し、ローカル環境にクローンを作成する。

2. 1で作成したクローンの<code>sinatra</code>というディレクトリに移動する。

3. 利用するgemをインストールするため、<code>bundle install</code>を実行する。 

4. app.rb(メモアプリの実行ファイル)を実行する： <code>bundle exec ruby app.rb</code>

5. ブラウザで動作を確認する。<code>http://localhost:4567/memos</code>と入力するとブラウザ上にメモアプリが表示される。

