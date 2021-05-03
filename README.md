# Shiori
![shiori-top](https://user-images.githubusercontent.com/18507447/107665175-8c6ec880-6cd0-11eb-917b-8f0ebc78756f.png)

## herokuにアプリを作成する
```
$ heroku create アプリケーション名
$ heroku addons:create heroku-postgresql:hobby-dev
$ heroku stack:set container
```

## Gemfileを変更したとき
docker-composeでbundle領域をdocker volumeにしている関係で、Dockerfileでbundle installできない。
そのため、下記のコマンドを用いて手動でbundle installを行う。
```
$ docker-compose run app bundle
```
