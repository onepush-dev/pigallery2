# PiGallery2 on Railway

[PiGallery2](https://github.com/bpatrik/pigallery2) (MIT): a fast, directory-first self-hosted photo and video gallery with search, map, faces, albums, sharing links, OIDC and uploads. Deploy it on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/2S1P7l)

## What this template runs
- **pigallery2**: `ghcr.io/onepush-dev/pigallery2:3.8.0`, the official `bpatrik/pigallery2:3.8.0` image (application unmodified). One volume at `/app/data` holds the config (`/app/data/config`), the SQLite database (`/app/data/db`), your photos (`/app/data/images`) and generated thumbnails (`/app/data/tmp`). Listens on port 8080; health check `/heartbeat`.

On first boot `railway/start.sh` writes `/app/data/config/config.json` with the admin account as an upstream *enforced user* (password from `PIGALLERY2_ADMIN_PASSWORD`, stored only as a hash), `trustProxy` on and uploads enabled for admins. The default `admin`/`admin` account is never created.

## Variables
| Variable | Value |
|---|---|
| `PIGALLERY2_ADMIN_PASSWORD` | `${{secret(24)}}`: password of the `admin` account (applied on first boot) |

## After deploy
1. Open the Railway URL and sign in as `admin` with `PIGALLERY2_ADMIN_PASSWORD`.
2. Add photos: open a folder and use **Upload** (admins), or mount/copy files into `/app/data/images`. Then run indexing from **Settings → Indexing** (or just browse; folders are indexed on demand).
3. Everything else (sharing, map, faces, OIDC, video transcoding) is under Settings.

Changing `PIGALLERY2_ADMIN_PASSWORD` after the first boot has no effect; change the password in the app. Docs: https://bpatrik.github.io/pigallery2/

Not affiliated with PiGallery2.
