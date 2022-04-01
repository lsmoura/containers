#!/bin/sh

set -e

if [ ! -z "$ETA_URL" ]; then 
	sed -i "s@\(.*\'eta\':\).*\$@\\1 '$ETA_URL',@" /app/couchpotato/core/media/movie/providers/info/couchpotatoapi.py
fi

if [ ! -z "$OMDB_APIKEY" ]; then
	sed -i "s@\(.*\'default\':\).*\$@\\1 '$OMDB_APIKEY',@" /app/couchpotato/core/media/movie/providers/info/omdbapi.py
fi

exec "$@"
