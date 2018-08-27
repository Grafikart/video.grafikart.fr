import { NextFunction, Request, Response } from 'express'

/**
 * Vérifie que l'utilisateur est premium!
 * @param req
 * @param res
 * @param next
 */
export default function (req: Request, res: Response, next: NextFunction): any {
  let premium = req.user.premium
  let error = new Error('Utilisateur non premium')
  error.name = 'UnauthorizedError'
  if (premium && Date.parse(premium) > new Date().getTime()) {
    next()
  } else {
    error = new Error('Utilisateur non premium')
    error.name = 'UnauthorizedError'
    next(error)
  }
}
