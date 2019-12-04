module.exports = {
  globals: {
    'ts-jest': {
      tsConfig: 'tsconfig.json'
    }
  },
  moduleFileExtensions: [
    'ts',
    'js',
    'json'
  ],
  transform: {
    "^.+\\.tsx?$": "ts-jest"
  },
  testMatch: [
    '**/test/**/*.test.(ts|js)'
  ],
  testEnvironment: 'node'
};
