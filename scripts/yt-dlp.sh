URL="$(cliphist list | grep "://" | fuzzel -d | cliphist decode)"
if [ -z "$URL" ]; then
	exit
fi

SITE="$(echo $URL | sed 's/[:\/.]/ /g' | awk '{print $3}')"

if [ "$SITE" == "youtube" ] || [ "$SITE" == "be" ]; then
	RES="$(printf '1440\n1080\n720\n480\n240\nnone' | fuzzel -d)"

	if [ "$RES" == "none" ]; then
		CMD="mpv --ytdl-format=\"ba\" --no-video $URL 2>/dev/null"
	else
		CMD="mpv --ytdl-format=\"bv*[height<=$RES]+ba\" $URL 2>/dev/null"
	fi

else
	CMD="mpv $URL"
fi

eval $CMD

DATE="$(date '+%Y-%m-%dT%H:%M:%S')"
TITLE="$(yt-dlp --simulate --print "%(title)s" $URL 2>/dev/null)"
CHANNEL="$(yt-dlp --simulate --print "%(channel)s" $URL 2>/dev/null)"
jq -n --arg date "$DATE" --arg channel "$CHANNEL" --arg title "$TITLE" --arg url "$URL" '{date: $date, channel: $channel, title: $title, url: $url}' >> ~/Documents/mpv_history.json
