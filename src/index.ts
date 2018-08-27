import express from 'express'
import jwt from 'express-jwt'
import premiumMiddleware from './middlewares/premium'
import secretMiddleware from './middlewares/secret'
import * as tutorielController from './controllers/tutoriel'
import * as videoController from './controllers/video'
import errorHandler from './middlewares/error'
import { json as jsonMiddleware } from 'body-parser'

require('dotenv').config()

if (process.env.NODE_ENV !== 'production') {
  process.on('unhandledRejection', r => console.log(r))
}

const app = express()
const jwtMiddleware = jwt({
  secret: process.env.JWT_SECRET,
  algorithms: ['HS256'],
  getToken: function (req) {
    return req.query.token
  }
})
app.use(jsonMiddleware())
app.get('/api/videos/stream', jwtMiddleware, premiumMiddleware, videoController.stream)
app.post('/api/sync', secretMiddleware, tutorielController.upload)
app.get('*', function (req, res) {
  return res.redirect('https://grafikart.fr')
})
app.use(errorHandler)
app.listen(4000, () => console.log('Server démarré'))
