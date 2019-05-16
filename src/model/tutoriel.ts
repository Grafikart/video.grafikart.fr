import path from 'path'

interface IFormation {
  name: string,
  slug: string,
  chapters: number,

  [key: string]: any
}

export default class Tutoriel {
  id: number
  name: string
  content: string
  createdAt: Date
  formation?: IFormation
  technologies: string[]
  slug: string
  video: string
  position: number
  youtube: string
  image: string
  playlist: string

  get url (): string {
    return `https://grafikart.fr/tutoriels/${this.slug}-${this.id}`
  }

  get title (): string {
    let name = this.name.replace(/[<>]/g, '')
    if (this.formation) {
      return `${this.formation.name} : Chapitre ${this.position}, ${name}`
    } else {
      return `Tutoriel ${this.technologies.join('/')} : ${name}`
    }
  }

  get isPublic (): boolean {
    return this.createdAt.getTime() < new Date().getTime()
  }

  get excerpt (): string {
    if (this.content.startsWith('<')) {
      return ''
    }
    return this.content
      .split(/(\r\n|\r|\n){2}/)[0]
      .replace(/[<>]/g, '')
  }

  get description (): string {
    return `Article ► ${this.url}
Abonnez-vous ► https://bit.ly/GrafikartSubscribe

${this.excerpt}

Soutenez Grafikart:
Devenez premium ► https://grafikart.fr/premium
Donnez via Utip ► https://utip.io/grafikart

Retrouvez Grafikart sur:
Le site ► https://grafikart.fr
Twitter ► https://twitter.com/grafikart_fr
Discord ► https://grafikart.fr/tchat`
  }

  get videoPath (): string {
    return path.join(process.env.VIDEO, this.video)
  }

  get thumbnailPath (): string {
    let dir = Math.ceil(this.id / 1000)
    return path.join(process.env.VIDEO, `../../public/uploads/tutoriels/${dir}/${this.image}`)
  }

  get youtubeParts () {
    return {
      snippet: {
        title: this.title,
        description: this.description,
        categoryId: '28',
        defaultLanguage: 'fr',
        defaultAudioLanguage: 'fr'
      },
      status: {
        privacyStatus: this.isPublic ? 'public' : 'private',
        embeddable: true,
        publicStatsViewable: false,
        publishAt: this.isPublic ? null : this.createdAt.toISOString()
      }
    }
  }

}
