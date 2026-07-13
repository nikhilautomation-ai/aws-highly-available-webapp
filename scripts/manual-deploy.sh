#!/bin/bash
set -euo pipefail

BUCKET_NAME="${1:-YOUR_PRIVATE_BUCKET_NAME}"
OBJECT_KEY="${2:-app-v1-deployment-package.zip}"
AWS_REGION="${3:-eu-west-1}"

PACKAGE_PATH="/tmp/app-deployment-package.zip"
EXTRACT_DIR="/tmp/ha-webapp"
NGINX_ROOT="/usr/share/nginx/html"

echo "Installing required packages..."
sudo dnf install -y awscli unzip nginx

echo "Starting Nginx..."
sudo systemctl enable --now nginx

echo "Downloading deployment artifact from S3..."
aws s3 cp \
  "s3://${BUCKET_NAME}/${OBJECT_KEY}" \
  "${PACKAGE_PATH}" \
  --region "${AWS_REGION}"

echo "Extracting application..."
rm -rf "${EXTRACT_DIR}"
mkdir -p "${EXTRACT_DIR}"
unzip -o "${PACKAGE_PATH}" -d "${EXTRACT_DIR}"

echo "Deploying to Nginx..."
sudo rm -rf "${NGINX_ROOT:?}/"*
sudo cp "${EXTRACT_DIR}/index.html" "${NGINX_ROOT}/index.html"
sudo chown -R nginx:nginx "${NGINX_ROOT}"
sudo systemctl restart nginx

echo "Deployment completed successfully."
curl --fail http://localhost
