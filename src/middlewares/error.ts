import { NextFunction, Request, Response } from 'express'

/**
 * Gère les erreurs
 * @param err
 * @param req
 * @param res
 * @param next
 */
export default function (err: any, req: Request, res: Response, next: NextFunction) {
  if (err.name === 'UnauthorizedError') {
    return res.status(403).send(err.message)
  }
  return res.send('Erreur')
}
