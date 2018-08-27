module.exports = {
  apps : [{
    name      : 'GrafiStream',
    script    : 'dist/index.js',
    env: {
      NODE_ENV: 'development'
    },
    env_production : {
      NODE_ENV: 'production'
    },
    output: './logs/out.log',
    error: './logs/error.log'
  }],
};
