#! /usr/bin/env bash

set -e

if [ "$SSM_ACTIVATE" = "true" ]; then
  amazon-ssm-agent -register -code "${ACTIVATE_CODE}" -id "${ACTIVATE_ID}" -region "ap-northeast-1" -y
  nohup amazon-ssm-agent > /dev/null &
fi

rails db:migrate

bundle exec puma
