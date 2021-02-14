# Shiori
![shiori-top](https://user-images.githubusercontent.com/18507447/107665175-8c6ec880-6cd0-11eb-917b-8f0ebc78756f.png)

https://www.shiori-portfolio.work/  
ポートフォリオ閲覧には、ゲストログイン(かんたんログイン)がご使用いただけます。
## 制作の背景
私はYoutubeなどでよく動画を観るのですが、長い動画になると前回どこまで観たかわからなくなってしまうことが多々ありました。
Youtubeは途中から再生する機能がありますが、うまく反映されていないときは少しづつ再生して探す必要がありました。　  

そこで本に栞をはさむように、簡単に続きの管理がしたいと考え、このアプリケーションを制作しました。


## 使用技術
### 開発環境
* macOS Catalina 10.15.7
### アプリケーション
* Rails 6.0.3
* ruby 2.6.6
* MySQL 8.0.20
* Nginx 1.17.6
* google-api-client
* rspec(capybara + headless chrome, mock(youtube apiのテスト))
* rubocop
* JavaScript(jQuery)
* scss
* Materializecss
### インフラ等
* GitHub(GitHub Flow, issue)
* Docker(開発・本番)
* docker-compose
* AWS(VPC, ALB, RDS, ECS Fargate, ECR, ACM, Route53, SES)
* Terraform(ECS周辺を除く)
* お名前.com(ドメインの取得)
* CircleCI(CI/CD)
  - push時に、rspec・rubocopを実行
  - mainブランチへのマージ時に、テストからAWSへのデプロイまでを実施

## 機能一覧
* アカウント管理(devise)
  - ユーザー登録
  - ログイン/ログアウト
* 動画一覧機能
* 動画登録機能(URL, タイトル, 動画時間, サムネイル)
* 動画情報自動取得機能(YouTube Data API)
  - youtubeのURLを指定した場合、タイトル・動画時間・サムネイルを自動で取得します
* 視聴時間記録機能
  - 開始と終了を記録(ex.15min〜50minまで)
  - 複数時間のマージ(ex.0min〜15min + 15min〜50min → 0min〜50min)
  - スクリーンショットの投稿(時間を入力するのが煩わしいときに使用)
* 動画検索機能
  - テキスト検索(タイトル, URLにヒット)
  - ステータスフィルタ(未視聴, 視聴中, など)
  - ソート(残り時間、動画時間)
* プレイリスト機能


## 工夫した点
* fatになったcontroller, modelをconcern, query objectを用いてリファクタリングした。
* 無限スクロールの実装
* プレイリストへの追加をajaxで実装
* youtube data apiを用いて動画情報入力の手間を削減
* 友人に実際に使って頂いて、フィードバックを反映

## 機能詳細

## ER図
![ER図](https://user-images.githubusercontent.com/18507447/107884816-4fa60a00-6f3a-11eb-8dd7-5ca93ca8f268.png)

共通部分とdevise生成項目は省略しています
## 改善点
* フロントエンドの知識が不足しているため、操作性等の改善に限界があった

