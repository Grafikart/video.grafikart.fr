import { Request, Response } from 'express'
import * as path from 'path'
import * as fs from 'fs'

/**
 * Renvoie la vidéo (pour le streaming)
 * @param req
 * @param res
 */
export const stream = function (req: Request, res: Response) {
  let video = req.query.path as string
  if (video.match(/^([a-z0-9-_ ]+\/)?[a-z0-9-_ ]+\.(mp4|mov)$/i) === null) {
    return res.status(403).send()
  }
  video = path.join(process.env.VIDEO, video)
  const stat = fs.statSync(video)
  const fileSize = stat.size
  const range = req.headers.range as string

  if (range) {
    const parts = range.replace(/bytes=/, '').split('-')
    const start = parseInt(parts[0], 10)
    const end = parts[1]
      ? parseInt(parts[1], 10)
      : fileSize - 1
    const chunksize = (end - start) + 1
    const file = fs.createReadStream(video, { start, end })
    const head = {
      'Content-Range': `bytes ${start}-${end}/${fileSize}`,
      'Accept-Ranges': 'bytes',
      'Content-Length': chunksize,
      'Content-Type': 'video/mp4'
    }

    res.writeHead(206, head)
    return file.pipe(res)
  } else {
    const head = {
      'Content-Length': fileSize,
      'Content-Type': 'video/mp4'
    }
    res.writeHead(200, head)
    return fs.createReadStream(video).pipe(res)
  }
}
