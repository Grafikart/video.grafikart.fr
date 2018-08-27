import { NextFunction, Request, Response } from 'express'

/**
 * Vérifie que l'utilisateur est premium!
 * @param req
 * @param res
 * @param next
 */
export default function (req: Request, res: Response, next: NextFunction): any {
  if (req.body.secret === process.env.JWT_SECRET) {
    next()
  } else {
    let error = new Error('Accès interdit')
    error.name = 'UnauthorizedError'
    next(error)
  }
}
