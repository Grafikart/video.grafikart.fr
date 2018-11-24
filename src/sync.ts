import Tutoriels from './database/tutoriels'
import Youtube from './api/youtube'

require('dotenv').config()

const main = async function () {
  let tutoriels = await Tutoriels.findAll()
  let youtube = await
  Youtube.fromRefreshToken(
    process.env.CLIENT_ID,
    process.env.CLIENT_SECRET,
    process.env.REFRESH_TOKEN
  )
  for (let k in tutoriels) {
    let tutoriel = tutoriels[k]
    if (tutoriel.youtube !== null && tutoriel.youtube !== '') {
      console.log(`> #${k} ${tutoriel.title} > ${tutoriel.youtube}`)
      youtube.update(tutoriel.youtube, tutoriel.youtubeParts).then(() => {
        console.log(`/> #${k} `)
      }).catch(e => {
        console.error(`#${k}`, e.message, e.response.data.error.errors)
      })
    }
  }
}

main().catch(e => console.error(e))
