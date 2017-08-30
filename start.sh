#!/usr/bin/env bash
# Initial setup
git pull origin master
MIX_ENV=prod mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
# yarn
# npm run deploy
# MIX_ENV=prod mix phoenix.digest

# Generate a new release
MIX_ENV=prod PORT=4000 mix release
_build/prod/rel/video_grafikart/bin/video_grafikart stop
PORT=4000 _build/prod/rel/video_grafikart/bin/video_grafikart start
