# PocketBase Railway Template

Deploy [PocketBase](https://pocketbase.io) to [Railway](https://railway.com) with one click.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/pocketbase)

## Quick Start

1. Click "Deploy on Railway" above
2. Add a volume (see below)
3. Add environment variables for admin account (see below)
4. Generate a domain
5. Login at `/_/`

## Add Persistent Storage

**Required** - without this, you lose all data on redeploy.

**Right-click on the project canvas** → **Add New** → **Volume**

Or: `Cmd+K` → type "volume" → **Create Volume**

When prompted:
- Select your PocketBase service
- Mount path: `/data`

## Create Admin Account

Click your service → **Variables** tab → Add:

| Variable | Value |
|----------|-------|
| `SUPERUSER_EMAIL` | your email |
| `SUPERUSER_PASSWORD` | your password |

The admin account is created automatically on startup.

After it's working, you can remove `SUPERUSER_PASSWORD` for security (the account persists in the database).

## Generate a Domain

Click your service → **Settings** tab → **Networking** → **Generate Domain**

Your instance will be at `https://[generated-name].railway.app`

Login at `/_/` with the credentials you set above.

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

## Email Setup (Resend)

To enable email verification, password resets, etc.

### 1. Get Resend API Key

1. Sign up at [resend.com](https://resend.com)
2. Go to [resend.com/domains](https://resend.com/domains)
3. Add your domain and add the DNS records they provide (DKIM, SPF)
4. Wait for verification (usually a few minutes)
5. Go to **API Keys** and create one

### 2. Configure PocketBase

In PocketBase admin (`/_/`) → **Settings** → **Mail settings**:

| Field | Value |
|-------|-------|
| Sender name | Your App Name |
| Sender address | `support@yourdomain.com` |
| SMTP server host | `smtp.resend.com` |
| Port | `587` (or `2587` if 587 doesn't work, 2587 is the one that worked for me.) |
| Username | `resend` |
| Password | Your Resend API key |

Click **Send test email** to verify it works.

**Note:** You must use a verified domain in the sender address. `@gmail.com` or `@example.com` won't work.

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
