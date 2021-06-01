#!/bin/sh

cat config/webpacker.yml
yarn install --check-files
rails db:migrate
