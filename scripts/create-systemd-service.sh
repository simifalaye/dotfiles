#!/usr/bin/env bash

set -e

#
# Defaults
#

SERVICE_USER="root"
RESTART_POLICY="always"
RESTART_SEC=5
DESCRIPTION="Custom systemd service"
TIMEOUT_STOP=30
EXEC_ARGS=""

#
# Help
#

usage() {
  cat <<EOF
Usage:
  sudo $0 [options] <service-name> <executable-path>

Options:

  -a, --args EXEC_ARGS          Run executable with args
  -u, --user USER             Run service as USER (default: root)
  -r, --restart POLICY        Restart policy (default: always)
  -s, --restart-sec SECONDS   Restart delay (default: 5)
  -d, --description TEXT      Service description
  -t, --timeout-stop SECONDS  Stop timeout (default: 30)
  -h, --help                  Show this help

Example:
  sudo $0 --user myuser my-service /usr/local/bin/my-script.sh
EOF
  exit 0
}

#
# Main
#

# Parse arguments
ARGS=$(getopt -o a:u:r:s:d:t:h --long args:,user:,restart:,restart-sec:,description:,timeout-stop:,help -n "$0" -- "$@")
eval set -- "$ARGS"
while true; do
  case "$1" in
    -a|--args)
      EXEC_ARGS="$2"
      shift 2
      ;;
    -u|--user)
      SERVICE_USER="$2"
      shift 2
      ;;
    -r|--restart)
      RESTART_POLICY="$2"
      shift 2
      ;;
    -s|--restart-sec)
      RESTART_SEC="$2"
      shift 2
      ;;
    -d|--description)
      DESCRIPTION="$2"
      shift 2
      ;;
    -t|--timeout-stop)
      TIMEOUT_STOP="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Positional arguments
SERVICE_NAME="$1"
EXECUTABLE_PATH="$2"
if [[ -z "$SERVICE_NAME" || -z "$EXECUTABLE_PATH" ]]; then
  echo "Error: service-name and executable-path are required"
  usage
fi
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# Validation
if [[ ! -x "$EXECUTABLE_PATH" ]]; then
  echo "Error: $EXECUTABLE_PATH does not exist or is not executable"
  exit 1
fi

if [[ -f "$SERVICE_FILE" ]]; then
  echo "Service ${SERVICE_NAME}.service already exists."
  exit 0
fi

# Create service
echo "Creating systemd service: ${SERVICE_NAME}.service"
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=$DESCRIPTION
After=network.target


[Service]
Type=simple
User=$SERVICE_USER
ExecStart=$EXECUTABLE_PATH $EXEC_ARGS
Restart=$RESTART_POLICY

RestartSec=${RESTART_SEC}s
KillSignal=SIGTERM
TimeoutStopSec=${TIMEOUT_STOP}

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"
echo "Service ${SERVICE_NAME}.service created and started."
