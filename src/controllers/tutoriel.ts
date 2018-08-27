import { Request, Response } from 'express'

export const upload = function (req: Request, res: Response) {
  res.send('Salut le monde')
}
