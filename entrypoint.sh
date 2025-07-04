#!/usr/bin/env bash
set -e

# read inputs
BUILD_CMD="${INPUT_BUILD_COMMAND}"
SERVE_CMD="${INPUT_SERVE_COMMAND}"
PORT="${INPUT_SERVE_PORT}"
API_URL="${INPUT_API_ENDPOINT}"
API_TOKEN="${INPUT_API_TOKEN}"
FAIL_ON="${INPUT_FAIL_ON_VIOLATION}"

echo "🔨 Building site"
eval "$BUILD_CMD"

echo "🌐 Starting server"
bash -c "$SERVE_CMD" & SERVER_PID=$!
sleep 5  # crude wait for server

echo "🕵️ Running checkineer!"
node /scripts/run-tests.js \
  --url "http://localhost:$PORT" \
  --api "$API_URL" \
  --token "$API_TOKEN" \
  --failOn "${FAIL_ON}"
TEST_EXIT=$?

kill $SERVER_PID
exit $TEST_EXIT
