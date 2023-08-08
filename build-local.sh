#!/bin/bash
set -e

wget "https://maclookup.app/downloads/json-database/get-db" -O src/mac-vendors-export.json
go build -buildvcs=false