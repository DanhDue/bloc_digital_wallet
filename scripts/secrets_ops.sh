#!/bin/bash

# Configuration
SECURE_FILES_DIR="secureFiles"
ENV_VAR_NAME="SECURE_FILES"

# Function to encode the folder
encode_secrets() {
    if [ ! -d "$SECURE_FILES_DIR" ]; then
        echo "Error: $SECURE_FILES_DIR directory not found."
        exit 1
    fi

    # Create a compressed tarball and convert to base64
    # -c: create, -z: gzip, -O: to stdout
    B64_DATA=$(tar -cz "$SECURE_FILES_DIR" | base64 | tr -d '\n')
    
    echo "================================================================"
    echo "COPY THE CONTENT BELOW AND SET IT AS '$ENV_VAR_NAME' IN YOUR CLOUD ENVIRONMENT"
    echo "================================================================"
    echo "$B64_DATA"
    echo "================================================================"
}

# Function to decode the folder
decode_secrets() {
    local B64_INPUT=$1
    if [ -z "$B64_INPUT" ]; then
        echo "No base64 data provided."
        return 1
    fi

    echo "Decoding secrets into $SECURE_FILES_DIR..."
    
    # Decode base64 and extract tarball
    echo "$B64_INPUT" | base64 -d | tar -xz
    
    if [ $? -eq 0 ]; then
        echo "Successfully reconstructed $SECURE_FILES_DIR"
    else
        echo "Error: Failed to decode secrets."
        return 1
    fi
}

# CLI Logic
case "$1" in
    encode)
        encode_secrets
        ;;
    decode)
        if [ -z "$2" ]; then
            echo "Usage: $0 decode <base64_string>"
            exit 1
        fi
        decode_secrets "$2"
        ;;
    *)
        echo "Usage: $0 {encode|decode <base64_string>}"
        exit 1
        ;;
esac
