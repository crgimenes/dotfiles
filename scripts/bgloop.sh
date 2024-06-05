#!/bin/zsh

LOCKFILE="/tmp/bgloop.lock"

if [ -e "${LOCKFILE}" ] && kill -0 "$(cat ${LOCKFILE})" 2>/dev/null; then
  #echo "Another instance of the script is already running."
  exit 0
fi

echo $$ > "${LOCKFILE}"

cleanup() {
  rm -f "${LOCKFILE}"
}

trap cleanup EXIT

iterm2_set_user_var() {
    printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64 | tr -d '\n')
}

while true; do
    sleep 1
    TOKINO="$(~/bin/internet_time -l -f '時の%.f')"
    iterm2_set_user_var tokino "$TOKINO"
done

