#!/bin/bash
set -e

./typesense-server --data-dir=/data --api-key=$TYPESENSE_API_KEY --enable-cors