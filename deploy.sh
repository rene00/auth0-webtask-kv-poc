#!/usr/bin/env bash

WT_NAME=kv-poc
WT_AUTH_SECRET=$1
test -z "${WT_AUTH_SECRET}" && WT_AUTH_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

wt rm ${WT_NAME}

wt create webtask.js \
    --no-parse \
    --no-merge \
    --name=${WT_NAME} \
    --dependency express \
    --dependency body-parser \
    --middleware @webtask/bearer-auth-middleware \
    --meta wt-middleware=@webtask/bearer-auth-middleware \
    --secret wt-auth-secret=${WT_AUTH_SECRET}
