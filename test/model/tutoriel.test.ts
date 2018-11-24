import Tutoriel from '../../src/model/tutoriel'

const dateWithOffset = function (offset = 0): Date {
  return new Date(new Date().getTime() + offset)
}

describe('Tutoriel', function () {

  let t = new Tutoriel()
  t.content = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris scelerisque malesuada tellus id ultrices. Suspendisse augue odio, dapibus id facilisis sit amet.

condimentum sed dolor. Duis rhoncus arcu a ligula finibus.`
  t.video = 'video.mp4'
  t.slug = 'video-test'
  t.image = 'test.png'
  t.id = 300
  t.createdAt = dateWithOffset(-3600)
  process.env.VIDEO = '/home/demo/downloads/videos'

  it('should get excerpt', function () {
    expect(t.excerpt).toBe(`Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris scelerisque malesuada tellus id ultrices. Suspendisse augue odio, dapibus id facilisis sit amet.`)
  })

  it('should get videoPath', function () {
    expect(t.videoPath).toBe('/home/demo/downloads/videos/video.mp4')
  })

  it('should get description', function () {
    expect(t.description).toEqual(expect.stringContaining(t.url))
    expect(t.description).toEqual(expect.stringContaining(t.description))
  })

  it('should get thumbnail path', function () {
    let t2 = Object.assign(new Tutoriel(), t, { id: 1324 })
    expect(t2.thumbnailPath).toBe('/home/demo/public/uploads/tutoriels/2/test.png')
  })

  it('should get visibility', function () {
    let t2 = Object.assign(new Tutoriel(), t, { createdAt: dateWithOffset(3700) })
    expect(t.isPublic).toBe(true)
    expect(t2.isPublic).toBe(false)
  })

  it('should get url', function () {
    expect(t.url).toBe('https://grafikart.fr/tutoriels/video-test-300')
  })

})
