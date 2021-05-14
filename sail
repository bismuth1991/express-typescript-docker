#!/bin/sh

create_empty_acme_cert_file_if_not_exists() {
    if [ ! -e letsencrypt/acme.json ]; then
        mkdir letsencrypt
        touch letsencrypt/acme.json
    fi
}

dev() {
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
}

deploy() {
    create_empty_acme_cert_file_if_not_exists
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
}

down() {
    docker-compose down --remove-orphans
}

logs() {
    docker-compose logs -f
}

case "$1" in
    dev)
        dev
        ;;
    deploy)
        deploy
        ;;
    down)
        down
        ;;
    logs)
        logs
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
    dev    ................... Start the app in development environment
    deploy ................... Build & deploy the app to production
    down   ................... Terminate the app
    logs   ................... Dump & follow the app's logs
EOF
        ;;
esac
