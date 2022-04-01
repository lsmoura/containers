# CouchPotato

This is a slim dockerfile from the [CouchPotatoServer](https://github.com/CouchPotato/CouchPotatoServer) project.

## Environment variables

This project is now archived by the owner and the helper api endpoints that the project uses are unavailable. Therefore, in the
interest of keeping this project functional, the following environment variables allows the user to point the calls to different
services:

* `ETA_URL` - defaults to `https://api.couchpota.to/eta/%s/`
* `OMDB_APIKEY`