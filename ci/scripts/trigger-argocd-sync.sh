#!/bin/bash
set -e
ARGOCD_SERVER="https://argocd.example.com"
APP_NAME="myapp"
curl -s -X POST -H "Authorization: Bearer ${ARGOCD_API_TOKEN}" \
  -H "Content-Type: application/json" \
  "${ARGOCD_SERVER}/api/v1/applications/${APP_NAME}/sync" -d '{"revision":"main"}'
