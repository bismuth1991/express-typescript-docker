import express from 'express'

const router = express.Router()

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' })
})

/* Health-check endpoint */
router.get('/health-check', (_, res) => {
  res.status(200).end()
})

export default router
