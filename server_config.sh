#!/bin/bash
set -e

# Ensure the directory exists
mkdir -p lib/util

# Detect the current Git branch
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $BRANCH_NAME"

# Define server URLs based on the branch
if [[ "$BRANCH_NAME" == "main" ]]; then
  THEWELL_GPT_SERVER_URL="http://thewell-gpt-lb-101888234.ap-northeast-2.elb.amazonaws.com"
else
  LOCAL_IP=$(ifconfig | grep -E 'inet (192\.|10\.|172\.)' | awk '{print $2}' | head -n 1)
  if [ -z "$LOCAL_IP" ]; then
      echo "No valid local IP address found. Defaulting to localhost."
      LOCAL_IP="127.0.0.1"
  fi
  THEWELL_GPT_SERVER_URL="http://$LOCAL_IP:8000"
fi

# Export the SERVER_URL as an environment variable

# Echo the Dart code into the file
cat <<EOF > lib/util/server_config.dart
String get gptServerUrl {
  const String defaultUrl = 'http://thewell-gpt-lb-101888234.ap-northeast-2.elb.amazonaws.com';

  const String envUrl = '$THEWELL_GPT_SERVER_URL';

  if (envUrl.isEmpty) {
    return defaultUrl;
  } else {
    return envUrl;
  }
}
EOF


echo "Using server URL: $THEWELL_GPT_SERVER_URL"