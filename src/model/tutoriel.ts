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

  get url (): string {
    return `https://www.grafikart.fr/tutoriels/${this.slug}-${this.id}`
  }

  get title (): string {
    if (this.formation) {
      return `${this.formation.name} (${this.position}/${this.formation.chapters}) : ${this.name}`
    } else {
      return `Tutoriel ${this.technologies.join('/')} : ${this.name}`
    }
  }

  get isPublic (): boolean {
    return this.createdAt.getTime() < new Date().getTime()
  }

  get excerpt (): string {
    return this.content.split(/(\r\n|\r|\n){2}/)[0]
  }

  get description (): string {
    return `Plus d'infos : ${this.url}

${this.excerpt}

Retrouvez tous les tutoriels sur https://www.grafikart.fr`
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
