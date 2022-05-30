#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

chmod +x "$SCRIPT_DIR/Tiles II.x86_64"
"$SCRIPT_DIR/Tiles II.x86_64"
