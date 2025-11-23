# PocketBase Railway Template

Deploy [PocketBase](https://pocketbase.io) to [Railway](https://railway.app) with one click.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/pocketbase)

## Setup Instructions

### 1. Deploy to Railway

Click the "Deploy on Railway" button above, or:

1. Fork this repository
2. Create a new project on [Railway](https://railway.app)
3. Connect your forked repository

### 2. Configure Persistent Storage (Required)

**This step is critical** - PocketBase uses SQLite, so you must attach a volume to persist your data.

1. Open the Railway Command Palette (`Cmd+K` on Mac, `Ctrl+K` on Windows/Linux)
2. Select **"Create Volume"**
3. Choose your PocketBase service
4. Set the mount path to: `/pb/pb_data`

### 3. Set Environment Variable

Add the following environment variable to your service:

| Variable | Value |
|----------|-------|
| `PORT` | `8080` |

### 4. Generate Domain

1. Go to your service **Settings**
2. Click **"Generate Domain"** under Networking
3. Your PocketBase instance will be available at `https://your-domain.railway.app`

---

## Creating an Admin Account

After your first deployment, you need to create a superuser (admin) account.

### Option 1: Web Installer (Recommended)

1. Navigate to `https://your-domain.railway.app/_/`
2. On first visit, PocketBase will show an installer screen
3. Enter your email and password to create the admin account

### Option 2: Check Railway Logs

Starting from PocketBase v0.23.0, the first-run installer URL with a secure token is printed in the logs:

1. Go to your Railway service
2. Click on **"Logs"**
3. Look for a URL like: `https://your-domain/_/#/pbinstall/[JWT_TOKEN]`
4. Click the link to complete setup

### Option 3: CLI (for local development)

```bash
./pocketbase superuser create your@email.com yourpassword
```

---

## Updating PocketBase

When a new version of PocketBase is released, follow these steps:

### Method 1: Update Dockerfile (Recommended)

1. Check the [latest PocketBase release](https://github.com/pocketbase/pocketbase/releases)
2. Update the `PB_VERSION` in your `Dockerfile`:
   ```dockerfile
   ARG PB_VERSION=0.35.0  # Change to latest version
   ```
3. Commit and push the change
4. Railway will automatically rebuild and deploy

### Method 2: Manual Rebuild with Build Arg

1. Go to your Railway service settings
2. Add a build argument: `PB_VERSION=0.35.0`
3. Trigger a redeploy

### Before Updating

**Always backup your data first!** See the backup section below.

Read the [PocketBase Changelog](https://github.com/pocketbase/pocketbase/blob/master/CHANGELOG.md) for breaking changes, especially for major version updates.

---

## Backing Up Your Database

### Method 1: Admin Dashboard (Easiest)

1. Go to `https://your-domain.railway.app/_/`
2. Navigate to **Settings** → **Backups**
3. Click **"Create backup"**
4. Download the ZIP file

### Method 2: Scheduled Backups

1. In the Admin Dashboard, go to **Settings** → **Backups**
2. Configure a cron schedule (e.g., `0 0 * * *` for daily at midnight UTC)
3. Optionally configure S3 storage for automatic offsite backups

### Method 3: S3 Storage (Recommended for Production)

1. Go to **Settings** → **Backups** → **S3 Storage**
2. Configure your S3-compatible storage:
   - Endpoint
   - Bucket name
   - Region
   - Access Key
   - Secret Key
3. Backups will be automatically uploaded to S3

### Method 4: API (for Automation)

PocketBase provides backup API endpoints (requires superuser auth):

```bash
# List backups
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://your-domain.railway.app/api/backups

# Create backup
curl -X POST -H "Authorization: Bearer YOUR_TOKEN" \
  https://your-domain.railway.app/api/backups

# Download backup
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://your-domain.railway.app/api/backups/backup_filename.zip -o backup.zip
```

### Backup Best Practices

- **Schedule regular backups** using the built-in cron feature
- **Use S3 storage** for offsite backups (supports any S3-compatible service)
- **Test your backups** by restoring to a local instance periodically
- **Backup before updates** - always create a backup before upgrading PocketBase

---

## Local Development

1. Download PocketBase from the [releases page](https://github.com/pocketbase/pocketbase/releases)
2. Extract and run:
   ```bash
   ./pocketbase serve
   ```
3. Access the admin UI at `http://127.0.0.1:8080/_/`

Or use Docker:

```bash
docker build -t pocketbase .
docker run -p 8080:8080 -v $(pwd)/pb_data:/pb/pb_data pocketbase
```

---

## Project Structure

```
.
├── Dockerfile          # PocketBase container configuration
├── railway.json        # Railway deployment settings
├── pb_migrations/      # Database migrations (auto-generated)
├── pb_hooks/           # Custom JavaScript hooks
└── README.md
```

---

## Resources

- [PocketBase Documentation](https://pocketbase.io/docs/)
- [PocketBase GitHub](https://github.com/pocketbase/pocketbase)
- [Railway Documentation](https://docs.railway.com/)
- [Railway Volumes Guide](https://docs.railway.com/guides/volumes)
