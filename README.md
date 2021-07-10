# Shiori
![shiori-top](https://user-images.githubusercontent.com/18507447/107665175-8c6ec880-6cd0-11eb-917b-8f0ebc78756f.png)

# ローカル環境
## Gemfileを変更したとき
docker-composeでbundle領域をdocker volumeにしている関係で、Dockerfileでbundle installできない。
そのため、下記のコマンドを用いて手動でbundle installを行う。
```
$ docker-compose run app bundle
```

# 本番環境
## herokuにアプリを作成する
```
$ heroku create アプリケーション名
$ heroku addons:create heroku-postgresql:hobby-dev
```

## 環境変数を設定する
```
$ heroku stack:set container
$ heroku config:set ARG_MYSQL_PASSWORD=
$ heroku config:set ARG_RAILS_MASTER_KEY=
$ heroku config:set AWS_ACCESS_KEY_ID=
$ heroku config:set AWS_SECRET_ACCESS_KEY=
$ heroku config:set DATABASE_HOST=
$ heroku config:set DATABASE_NAME=
$ heroku config:set DATABASE_PASSWORD=
$ heroku config:set DATABASE_URL=
$ heroku config:set DATABASE_USER=
$ heroku config:set GMAIL_PASSWORD=
$ heroku config:set GMAIL_USER_NAME=
$ heroku config:set MYSQL_PASSWORD=
$ heroku config:set RACK_ENV=
$ heroku config:set RACK_TIMEOUT_SERVICE_TIMEOUT=
$ heroku config:set RAILS_ENV=
$ heroku config:set RAILS_LOG_TO_STDOUT=
$ heroku config:set RAILS_SERVE_STATIC_FILES=
$ heroku config:set S3_ACCESS_KEY=
$ heroku config:set S3_BUCKET=
$ heroku config:set S3_REGION=
$ heroku config:set S3_SECRET_KEY=
$ heroku config:set SECRET_KEY_BASE=
$ heroku config:set YOUTUBE_DATA_API_KEY=
```

## デプロイ
```
$ heroku container:push web --arg ARG_RAILS_MASTER_KEY=replace_rails_master_key,ARG_DATABASE_PASSWORD=replace_database_password
$ heroku container:release web
```

## 定期的にアクセスを発生させる
https://uptimerobot.com/
