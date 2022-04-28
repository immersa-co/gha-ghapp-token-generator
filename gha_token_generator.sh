#!/bin/bash

timestamp() {
  date +"%s"
}

payload=$( jq -n \
    --arg iat "$(timestamp)" \
    --arg iss "$APPID" \
    --arg exp "$(($(timestamp)+600))" \
    '{
        "iat": $iat | tonumber,
        "iss": $iss | tonumber,
        "exp": $exp | tonumber
    }'
)

set -o pipefail

header_template=$( jq -n \
    --arg typ "JWT" \
    --arg alg "RS256" \
    '{typ: $typ, alg: $alg}'
)

b64enc() { openssl enc -base64 -A | tr '+/' '-_' | tr -d '='; }
json() { jq -c . | LC_CTYPE=C tr -d '\n'; }
rs_sign() { openssl dgst -binary -sha"${1}" -sign <(printf '%s\n' "$2"); }

get_jwt_token() {
  algo=RS256
  header=$header_template || return
  signed_content="$(json <<<"$header" | b64enc).$(json <<<"$payload" | b64enc)"
  sig=$(printf %s "$signed_content" | rs_sign "${algo#RS}" "$PRIVATEKEY" | b64enc)
  printf '%s.%s\n' "${signed_content}" "${sig}"
}

fetch_gha_token() {
  jwt_token=$(get_jwt_token)
  response=$(curl -s -X POST \
             -H "Authorization: Bearer $jwt_token" \
             -H "Accept: application/vnd.github.v3+json" \
             https://api.github.com/app/installations/"$INSTALLID"/access_tokens)
  token=$(echo $response | jq -r .token)
  printf "%s" "${token}"
}

fetch_gha_token
