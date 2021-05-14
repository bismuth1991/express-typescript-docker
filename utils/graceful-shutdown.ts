import debug from 'debug'
import {Server} from 'http';
import {createTerminus} from '@godaddy/terminus'

const log = debug('app:terminus')

function onSignal () {
    log('Recieved shutdown signal')
    log('Gracefully shutting down...')

    return Promise.all([
        // Cleanup logic, eg. closing database connections
    ]);
}

function beforeShutdown () {
    // Recommended for Kubernetes.
    // https://github.com/godaddy/terminus#how-to-set-terminus-up-with-kubernetes
    return new Promise(resolve => {
        setTimeout(resolve, 5000)
    })
}

function onShutdown () {
    return Promise.resolve()
}

function onHealthCheck () {
    return Promise.all([
        // Healthcheck logic
    ])
        .then(() => log('Healthcheck ok'))
        .catch((e: unknown) => {
            log('Healthcheck failed')
            throw e
        })
}

function enableGracefulShutdown (server: Server) {
    return createTerminus(server, {
        healthChecks: {
            '/healthcheck': onHealthCheck,
        },
        timeout: 10000,                  
        signals: ['SIGTERM', 'SIGINT'],
        beforeShutdown,
        onSignal,                        
        onShutdown,                      
    })
} 

export default enableGracefulShutdown
