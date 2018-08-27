export class NotFoundRecord extends Error {

  constructor () {
    super()
    this.message = 'Enregistrement introuvable'
  }

}
