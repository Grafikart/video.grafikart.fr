import chai from 'chai'
import spies from 'chai-spies'

chai.use(spies)

process.on('unhandledRejection', () => null)

const expect = chai.expect

export {
  chai,
  expect
}
