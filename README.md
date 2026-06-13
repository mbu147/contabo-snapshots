# Contabo VPS Automatic Snapshots

Automatically creates a snapshot of all your Contabo VPS instances and deletes the previous one.
Supports both **one-shot** and **scheduled (cron)** modes.

## Environment Variables

| Variable        | Required | Default  | Description                                                        |
|-----------------|----------|----------|--------------------------------------------------------------------|
| `CLIENTID`      | Yes      |          | Contabo API client ID                                              |
| `CLIENTSECRET`  | Yes      |          | Contabo API client secret                                          |
| `USER`          | Yes      |          | Contabo account email                                              |
| `PASSWORD`      | Yes      |          | Contabo account password                                           |
| `CRON_SCHEDULE` | No       |          | Cron expression (e.g. `0 3 * * *`). If unset, runs once and exits |
| `SNAPSHOT_NAME` | No       | `daily`  | Name given to created snapshots                                    |

## Usage

### One-shot (run once and exit)

```sh
docker run --rm \
  -e CLIENTID=<client_id> \
  -e CLIENTSECRET=<client_secret> \
  -e USER=<email> \
  -e PASSWORD=<password> \
  contabo-snapshots
```

### Scheduled (keep running on a cron schedule)

```sh
docker run -d \
  -e CLIENTID=<client_id> \
  -e CLIENTSECRET=<client_secret> \
  -e USER=<email> \
  -e PASSWORD=<password> \
  -e CRON_SCHEDULE="0 3 * * *" \
  --restart unless-stopped \
  --name contabo-snapshots \
  contabo-snapshots
```

This example takes a snapshot every day at 03:00. Logs are visible via `docker logs contabo-snapshots`.

### Docker Compose

```yaml
services:
  contabo-snapshots:
    image: contabo-snapshots
    restart: unless-stopped
    environment:
      CLIENTID: <client_id>
      CLIENTSECRET: <client_secret>
      USER: <email>
      PASSWORD: <password>
      CRON_SCHEDULE: "0 3 * * *"
      SNAPSHOT_NAME: daily
```

## Build

```sh
docker build -t contabo-snapshots .
```
