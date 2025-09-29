#!/bin/bash

echo "=== Generate RPC Secret ==="
echo

if command -v openssl &> /dev/null; then
    echo "Generated RPC Secret:"
    openssl rand -hex 16
    echo
    echo "Copy this value and use it as DRONE_RPC_SECRET in your .env file"
elif command -v head &> /dev/null && command -v tr &> /dev/null; then
    echo "Generated RPC Secret:"
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 && echo
    echo
    echo "Copy this value and use it as DRONE_RPC_SECRET in your .env file"
else
    echo "Cannot generate random secret. Please install openssl or use online generator."
    echo "Visit: https://www.random.org/strings/"
    echo "Generate a 32-character alphanumeric string"
fi