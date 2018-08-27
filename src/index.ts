import express from 'express'
import jwt from 'express-jwt'
import premiumMiddleware from './middlewares/premium'
import * as tutorielController from './controllers/tutoriel'
import * as videoController from './controllers/video'
import errorHandler from './middlewares/error'

require('dotenv').config()

const app = express()
const jwtMiddleware = jwt({
  secret: process.env.JWT_SECRET,
  algorithms: ['HS256'],
  getToken: function (req) {
    return req.query.token
  }
})
app.get('/api/videos/stream', jwtMiddleware, premiumMiddleware, videoController.stream)
app.post('/api/sync', tutorielController.upload)
app.use(errorHandler)
app.listen(4000, () => console.log('Server démarré'))
