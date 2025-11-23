# PocketBase Railway Template

Deploy [PocketBase](https://pocketbase.io) to [Railway](https://railway.com) with one click.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/pocketbase)

## Quick Start

1. Click "Deploy on Railway" above
2. Add a volume (see below)
3. Generate a domain
4. Visit `/_/` to create your admin account

## Add Persistent Storage

**Required** - without this, you lose all data on redeploy.

**Right-click on the project canvas** → **Add New** → **Volume**

Or: `Cmd+K` → type "volume" → **Create Volume**

When prompted:
- Select your PocketBase service
- Mount path: `/data`

## Generate a Domain

Click your service → **Settings** tab → **Networking** → **Generate Domain**

Your instance will be at `https://[generated-name].railway.app`

---

## Create Admin Account

After first deploy, go to `https://your-domain.railway.app/_/`

PocketBase shows an installer screen. Enter email + password. Done.

---

## Update PocketBase

1. Edit `Dockerfile`, change `PB_VERSION`:
   ```dockerfile
   ARG PB_VERSION=0.35.0
   ```
2. Commit and push
3. Railway auto-redeploys

**Backup first.** Check the [changelog](https://github.com/pocketbase/pocketbase/blob/master/CHANGELOG.md) for breaking changes.

---

## Backups

### Via Admin UI

`/_/` → **Settings** → **Backups** → **Create backup** → Download ZIP

### Scheduled Backups

Same place, set a cron (e.g. `0 0 * * *` for daily at midnight UTC).

### S3 Storage

**Settings** → **Backups** → configure S3 endpoint, bucket, keys. Backups upload automatically.

---

## Local Dev

```bash
# Download from https://github.com/pocketbase/pocketbase/releases
./pocketbase serve
# Admin UI: http://127.0.0.1:8080/_/
```

Or with Docker:

```bash
docker build -t pocketbase .
docker run -p 8080:8080 -v $(pwd)/pb_data:/data pocketbase
```

---

## Project Structure

```
├── Dockerfile        # Multi-stage build, non-root user, tini
├── entrypoint.sh     # Reads $PORT, runs as pocketbase user
├── railway.json      # Railway config
├── pb_migrations/    # Your migrations
├── pb_hooks/         # Your hooks
```

## Links

- [PocketBase Docs](https://pocketbase.io/docs/)
- [Railway Volumes Guide](https://docs.railway.com/guides/volumes)
