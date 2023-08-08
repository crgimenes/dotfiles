# Desc: Google Translate from command line

gtr() {
  sl=auto
  tl=pt
  shift
  qry="$*"
  ua='Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/109.0'
  base_url='https://translate.googleapis.com/translate_a/single'

  resp="$(curl \
    --silent \
    --get \
    --user-agent "$ua" \
    --data client=gtx \
    --data sl="$sl" \
    --data tl="$tl" \
    --data dt=t \
    --data-urlencode q="$qry" \
    "$base_url")"
  echo "$resp" |
      sed 's/","/\n/g' |
      sed -E 's/\[|\]|"//g' |
      head -1
}

