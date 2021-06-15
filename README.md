# このリポジトリについて
Sinatraを使ったシンプルなWebアプリのリポジトリ

# ローカルでアプリケーションを立ち上げるための手順
1. <code>git clone -b dev_db https://github.com/Nabegon/sinatra.git</code> を実行し、ローカル環境にクローンを作成する。

2. 1で作成したクローンの<code>sinatra</code>というディレクトリに移動する。

3. 利用するgemをインストールするため、<code>bundle install</code>を実行する。 

4. app.rb(メモアプリの実行ファイル)を実行する： <code>bundle exec ruby app.rb</code>

5. ブラウザで動作を確認する。<code>http://localhost:4567/memos</code>と入力するとブラウザ上にメモアプリが表示される。

