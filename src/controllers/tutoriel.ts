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
  try {
    if (tutoriel.youtube === null || tutoriel.youtube === '') {
      let response = await youtube.upload(tutoriel.videoPath, tutoriel.youtubeParts)
      tutoriel.youtube = response.id
      await Tutoriels.updateYoutube(tutoriel.id, response.id)
      // if (tutoriel.playlist) {
      //   await youtube.addtoPlaylist(tutoriel.youtube, tutoriel.playlist)
      // }
    } else {
      await youtube.update(tutoriel.youtube, tutoriel.youtubeParts)
      await youtube.thumbnail(tutoriel.youtube, tutoriel.thumbnailPath)
    }
  } catch (e) {
    console.error(`API Error ${e.config.url} => ${e.response.data.message}`, e.response.data.error.errors, e.config.data)
  }
}

export const upload = async function (req: Request, res: Response) {
  try {
    let tutoriel = await Tutoriels.find(req.body.id)
    res.send('hello')
    uploadTutoriel(tutoriel).catch(console.error)
  } catch (e) {
    res.status(500).send(e.message)
  }
}
