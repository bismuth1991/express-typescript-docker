#!/bin/sh

case "$1" in
    dev)
        docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
        ;;
    deploy)
        docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
        ;;
    down)
        docker-compose down --remove-orphans
        ;;
    logs)
        docker-compose logs -f
        ;;
    *)
        cat << EOF
Command line interface to quickly run docker-compose commands. This assumes that you have already set up the following 3 files:
    (1) docker-compose.yml 
    (2) docker-compose.dev.yml
    (3) docker-compose.prod.yml

Usage:
    sail <command>

Available commands:
    dev    ................... Start the app in DEV environment
    deploy ................... Build & deploy the app to production
    down   ................... Terminate the app
    logs   ................... Dump & follow the app's logs
EOF
        ;;
esac
