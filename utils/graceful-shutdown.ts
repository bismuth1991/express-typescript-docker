import {Server} from 'http';
import {createTerminus} from '@godaddy/terminus'

function onSignal () {
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
}

const options = {
    healthChecks: {
        '/healthcheck': onHealthCheck,
    },
    timeout: 10000,                  
    signals: ['SIGTERM', 'SIGINT'],
    beforeShutdown,
    onSignal,                        
    onShutdown,                      
};

const enableGracefulShutdown = (server: Server) => createTerminus(server, options)

export default enableGracefulShutdown
