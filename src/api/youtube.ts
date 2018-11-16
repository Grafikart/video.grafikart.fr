import axios, { AxiosInstance, AxiosResponse } from 'axios'
import * as fs from 'fs'

interface YoutubeResponse {
  kind: 'youtube#video',
  etag: string
  id: string,
  snippet:
    {
      publishedAt: string,
      channelId: string,
      title: string,
      description: string,
      thumbnails: { default: object, medium: object, high: object },
      channelTitle: string,
      categoryId: string,
      liveBroadcastContent: string,
      defaultLanguage: string,
      localized: { title: string, description: string },
      defaultAudioLanguage: string
    },
  status:
    {
      uploadStatus: string,
      privacyStatus: string,
      license: string,
      embeddable: true,
      publicStatsViewable: false
    }
}

export default class Youtube {

  private axios: AxiosInstance

  /**
   * Génère une nouvelle instance à partir d'un refresh token
   * @param clientId
   * @param clientSecret
   * @param refreshToken
   */
  static async fromRefreshToken (clientId: string, clientSecret: string, refreshToken: string) {
    const response: AxiosResponse<{ access_token: string }> = await axios.post('https://www.googleapis.com/oauth2/v4/token', {
      grant_type: 'refresh_token',
      client_id: clientId,
      client_secret: clientSecret,
      refresh_token: refreshToken
    })
    return new Youtube(response.data.access_token)
  }

  constructor (accessToken: string) {
    this.axios = axios.create({
      baseURL: 'https://www.googleapis.com/',
      timeout: 10000,
      maxContentLength: Math.pow(2, 31),
      headers: {
        Authorization: 'Bearer ' + accessToken
      }
    })
  }

  /**
   * Upload une vidéo sur youtube
   * @param file
   * @param parts
   */
  public async upload (file: string, parts: object): Promise<YoutubeResponse> {
    const url = 'upload/youtube/v3/videos?uploadType=resumable&part=' + Object.keys(parts).join(',')
    const createResponse = await this.axios.post(url, parts)
    const uploadResponse: AxiosResponse<YoutubeResponse> = await this.axios.put(
      createResponse.headers.location,
      fs.createReadStream(file)
    )
    return uploadResponse.data
  }

  /**
   * Met à jour les informations d'une vidéo
   * @param id
   * @param parts
   */
  public async update (id: string, parts: object): Promise<YoutubeResponse> {
    const response: AxiosResponse<YoutubeResponse> = await this.axios.put(
      'youtube/v3/videos?part=' + Object.keys(parts).join(','),
      { id, ...parts }
    )
    return response.data
  }

  /**
   * Envoie la miniature
   * @param id
   * @param file
   */
  public async thumbnail (id: string, file: string): Promise<YoutubeResponse> {
    const url = `upload/youtube/v3/thumbnails/set?videoId=${id}&uploadType=resumable`
    const createResponse = await this.axios.post(url)
    const uploadResponse: AxiosResponse<YoutubeResponse> = await this.axios.put(
      createResponse.headers.location,
      fs.createReadStream(file)
    )
    return uploadResponse.data
  }

}
