#!/bin/sh
# First boot: write config.json with a generated admin password (upstream enforced user) so admin/admin never exists.
set -e
CFG=/app/data/config/config.json
mkdir -p /app/data/config /app/data/db /app/data/images /app/data/tmp
if [ ! -f "$CFG" ]; then
  if [ -z "$PIGALLERY2_ADMIN_PASSWORD" ]; then
    echo "[railway] PIGALLERY2_ADMIN_PASSWORD is empty; refusing to start with the default admin/admin account" >&2
    exit 1
  fi
  node -e '
const fs = require("fs");
const cfg = {
  Server: { port: 8080, trustProxy: "true" },
  Database: { dbFolder: "/app/data/db" },
  Media: { folder: "/app/data/images", tempFolder: "/app/data/tmp" },
  Extensions: { folder: "/app/data/config/extensions" },
  Users: { authenticationRequired: true, enforcedUsers: [ { name: process.env.PIGALLERY2_ADMIN_USER || "admin", role: "Admin", password: process.env.PIGALLERY2_ADMIN_PASSWORD } ] },
  Upload: { enabled: true }
};
fs.writeFileSync(process.argv[1], JSON.stringify(cfg, null, 2));
' "$CFG"
  echo "[railway] wrote $CFG: admin user '${PIGALLERY2_ADMIN_USER:-admin}' with the password from PIGALLERY2_ADMIN_PASSWORD (first boot)"
fi
cd /app
# Railway does not pass the image's hyphenated "default-*" variables to the process, so set them here.
exec env \
  "default-Database-dbFolder=/app/data/db" \
  "default-Media-folder=/app/data/images" \
  "default-Media-tempFolder=/app/data/tmp" \
  "default-Extensions-folder=/app/data/config/extensions" \
  "default-Server-port=8080" \
  "default-Server-trustProxy=true" \
  PI_DOCKER=true NODE_ENV=production \
  node --expose-gc ./src/backend/index --config-path="$CFG"
