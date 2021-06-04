#!/bin/sh

rails webpacker:compile
rails db:migrate RAILS_ENV=production
