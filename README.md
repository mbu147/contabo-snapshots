# Contabo VPS automatic Snapshots
This script automatically creates a snapshot of your Contabo VPS Servers and deletes the old one.<br >
Currently only one snapshot with name "daily" at the same time is supported.Old one will be deleted first.<br />
Feel free to edit this :-)

## Usage
Build Dockerfile
```
docker build -t contabo-snapshots .
```
Execute container with credentials as environment (from your Contabo Control Panel)
- CLIENTID
- CLIENTSECRET
- USER
- PASSWORD
```
docker run --rm -e CLIENTID=<client id> -e CLIENTSECRET=<client secret> -e USER=<api user> -e PASSWORD=<api password> contabo-snapshots
```
