# このリポジトリについて
Sinatraを使ったシンプルなWebアプリのリポジトリ

# ローカルでアプリケーションを立ち上げるための手順
1. <code>git clone -b dev_sinatra https://github.com/Nabegon/sinatra.git</code> を実行し、ローカル環境にクローンを作成する。

2．<code>bundle init</code>でGemfileを作成する。<code>nano Gemfile</code>で作成したGemfileを開き、<code>gem "sinatra"</code>と記入し、保存して閉じる。

3. sinatraをインストールする：<code>Gem install sinatra</code>

4. 1で作成したクローンの<code>sinatra</code>というディレクトリに移動する。

5. app.rb(メモアプリの実行ファイル)を実行する： <code>bundle exec ruby app.rb</code>

6. ブラウザで動作を確認する。<code>http://localhost:4567/memos</code>と入力するとブラウザ上にメモアプリが表示される。

