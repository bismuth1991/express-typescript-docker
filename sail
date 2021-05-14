#!/bin/bash

check_file_requirements_dev() {
    if  [ ! -f docker-compose.yml ]; then
        echo "Missing file: docker-compose.yml"
        exit 1
    elif  [ ! -f docker-compose.dev.yml ]; then
        echo "Missing file: docker-compose.dev.yml"
        exit 1
    elif [ ! -f .env.development ]; then
        echo "Missing file: .env.development"
        exit 1
    fi
}

check_file_requirements_prod() {
    if  [ ! -f docker-compose.yml ]; then
        echo "Missing file: docker-compose.yml"
        exit 1
    elif  [ ! -f docker-compose.prod.yml ]; then
        echo "Missing file: docker-compose.prod.yml"
        exit 1
    elif  [ ! -f .env.production ]; then
        echo "Missing file: .env.production"
        exit 1
    fi
}

create_empty_acme_cert_file_if_not_exists() {
    if [ ! -e letsencrypt/acme.json ]; then
        mkdir letsencrypt
        touch letsencrypt/acme.json
    fi
}

dev() {
    check_file_requirements_dev
    docker-compose \
        --env-file .env.development \
        --file docker-compose.yml \
        --file docker-compose.dev.yml \
        up \
        --build \
        --detach
}

deploy() {
    check_file_requirements_prod
    create_empty_acme_cert_file_if_not_exists
    docker-compose \
        --env-file .env.production \
        --file docker-compose.yml \
        --file docker-compose.prod.yml \
        up \
        --build \
        --detach
}

down() {
    docker-compose down --remove-orphans
}

logs() {
    docker-compose logs -f
}

run_test() {
    docker-compose exec express npm run test
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
    test)
        run_test
        ;;
    *)
        cat << EOF
Command line interface to quickly run docker-compose commands. Make sure that you have already set up the following files in your project root folder:
    (1) docker-compose.yml 
    (2) docker-compose.dev.yml
    (3) docker-compose.prod.yml
    (4) .env.development
    (5) .env.production

Usage:
    sail <command>

Available commands:
    dev .................... Start the app in DEV environment
    deploy ................. Build & deploy the app to production
    down ................... Terminate the app
    logs ................... Dump & follow the app's logs
    test ................... Run test inside Docker DEV environment
EOF
        ;;
esac
