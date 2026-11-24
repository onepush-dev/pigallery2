# PiGallery2 on Railway: the official bpatrik/pigallery2:3.8.0 image (MIT), application unmodified.
# Railway layer: config, SQLite database, photos and thumbnails all live on one volume at /app/data, the server
# listens on 8080 and trusts Railway's proxy, and railway/start.sh writes the first config.json with the admin
# account as an upstream "enforced user" whose password comes from PIGALLERY2_ADMIN_PASSWORD, so the default
# admin/admin account is never created.
FROM bpatrik/pigallery2:3.8.0
LABEL org.opencontainers.image.source="https://github.com/onepush-dev/pigallery2"
COPY railway/start.sh /railway-start.sh
RUN chmod +x /railway-start.sh
ENV default-Server-port=8080 \
    default-Server-trustProxy=true \
    PIGALLERY2_ADMIN_USER=admin
EXPOSE 8080
HEALTHCHECK NONE
ENTRYPOINT ["/railway-start.sh"]
