#!/usr/bin/env bash

set -e

WT_NAME=kv-poc
WT_URL=$(wt inspect ${WT_NAME} --output json | jq .webtask_url -r)
WT_AUTH_SECRET=$(wt inspect ${WT_NAME} --decrypt --output json | jq '.ectx["wt-auth-secret"]' -r)
CURL="curl -s -f"

function date_calc() {
    echo $(date -d "$1 days")
}

# 401
echo "Checking 401"
set +e
${CURL} -X GET ${WT_URL}
test $? == 22 || exit
set -e

# POST
echo "Adding test key values."
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" -X POST ${WT_URL} \
    -o /dev/null -d "key=yesterday" -d "value=$(date_calc -1)"
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" -X POST ${WT_URL} \
    -o /dev/null -d "key=now" -d "value=$(date_calc 0)"
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" -X POST ${WT_URL} \
    -o /dev/null -d "key=tomorrow" -d "value=$(date_calc +11)"
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" -X POST ${WT_URL} \
    -o /dev/null -d "key=next_week" -d "value=$(date_calc +7)"
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" -X POST ${WT_URL} \
    -o /dev/null -d "key=next_month" -d "value=$(date_calc +31)"
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" -X POST ${WT_URL} \
    -o /dev/null -d "key=next_year" -d "value=$(date_calc +365)"

# GET
echo "Displaying all keys."
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" -X GET ${WT_URL} | jq '.'

echo "Displaying a single key."
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" \
    -X GET ${WT_URL}/next_year && echo

# DELETE
echo "Deleting a valid key."
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" \
    -X DELETE ${WT_URL}/yesterday -o /dev/null
curl -s -o /dev/null -X GET ${WT_URL}/yesterday

echo "Attempting to delete an invalid key."
set +e
${CURL} -H "Authorization: Bearer $WT_AUTH_SECRET" \
    -o /dev/null -X GET ${WT_URL}/$(date +s)
test $? == 22 || exit
set -e

echo "Test successful"
