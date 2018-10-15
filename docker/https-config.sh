#!/bin/bash
set -e

### Prepare configs
cat > /app/config/config_dev.json << EndOfConfig
{
  "mailer": {
    "smtp": {
      "addr": "$SMTP_HOST",
      "auth": {
        "username": "$SMTP_USERNAME",
        "password": "$SMTP_PASSWORD",
        "identity": "$SMTP_IDENTITY"
      }
    }
  },
  "translate": {
    "langs": "en, pl",
    "default": "en"
  },
  "router": {
    "host": ":443",
    "security": {
      "mode": "TLS",
      "cert": "/certs/$CICD_CERT/fullchain.pem",
      "key": "/certs/$CICD_CERT/privkey.pem"
    }
  },
  "database": {
    "engine": "sqlite3",
    "url": "file:main.db"
  },
  "app": {
    "baseURL": "$APP_BASE_URL"
  },
  "oauth": {
    "github": {
      "app": "$OAUTH_GITHUB_APP",
      "secret": "$OAUTH_GITHUB_SECRET"
    }
  },
  "api": {
    "secrets": "$API_SECRET"
  }
}
EndOfConfig

cp /app/config/config_dev.json /app/config/config_prod.json
cp /app/config/config_dev.json /app/config/config_test.json
