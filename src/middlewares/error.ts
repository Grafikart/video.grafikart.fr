import { NextFunction, Request, Response } from 'express'

/**
 * Gère les erreurs
 * @param err
 * @param req
 * @param res
 * @param next
 */
export default function (err: any, req: Request, res: Response, next: NextFunction) {
  if (process.env.NODE_ENV !== 'production') {
    console.error(err)
  }
  if (err.name === 'UnauthorizedError') {
    return res.status(403).send(err.message)
  }
  console.log(err.name)
  return res.send('Erreur')
}
