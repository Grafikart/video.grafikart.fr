import { Request, Response } from 'express'
import Youtube from '../api/youtube'
import Tutoriels from '../database/tutoriels'
import Tutoriel from '../model/tutoriel'

const uploadTutoriel = async function (tutoriel: Tutoriel) {
  let youtube = await
    Youtube.fromRefreshToken(
      process.env.CLIENT_ID,
      process.env.CLIENT_SECRET,
      process.env.REFRESH_TOKEN
    )
  if (tutoriel.youtube === null) {
    let response = await youtube.upload(tutoriel.videoPath, tutoriel.youtubeParts)
    await Tutoriels.updateYoutube(tutoriel.id, response.id)
  } else {
    await youtube.update(tutoriel.youtube, tutoriel.youtubeParts)
  }
  await youtube.thumbnail(tutoriel.youtube, tutoriel.thumbnailPath)
}

export const upload = async function (req: Request, res: Response) {
  try {
    let tutoriel = await Tutoriels.find(req.body.id)
    res.send('hello')
    uploadTutoriel(tutoriel).catch(console.error)
  } catch (e) {
    res.send(e.message)
  }
}
