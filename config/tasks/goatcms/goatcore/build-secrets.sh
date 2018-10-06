#!/bin/bash
set -e

cat > /data/code/goatcms/goatcore-prod/src/github.com/goatcms/goatcore/tests/smtp.json << EndOfMessage
{
  "sender": {
    "smtpAddr": "smtp.gmail.com:465",
    "authUsername": "$SMTP_USERNAME",
    "authPassword": "$SMTP_PASSWRD",
    "authIdentity": ""
  },
  "fromAddress": "$SMTP_TEST_FROM",
  "toAddress": "$SMTP_TEST_TO"
}
EndOfMessage
