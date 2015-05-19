plan      = require('flightplan')
appName   = 'nebulent-rac-ui'
username  = 'deploy'
startFile = '/var/www/rac-client'
tmpDir    = appName+'-' + new Date().getTime()

# configuration
plan.target 'production', [
    host: '45.55.130.11'
    username: deploy
    agent: process.env.SSH_AUTH_SOCK
]

# run commands on localhost
plan.local (local) ->
  # uncomment these if you need to run a build on your machine first
  # local.log('Run build');
  # local.exec('gulp build');
  local.log 'Copy files to remote hosts'
  filesToCopy = local.exec('git ls-files', silent: true)
  # rsync files to all the destination's hosts
  local.transfer filesToCopy, '/tmp/' + tmpDir
  return
# run commands on remote hosts (destinations)
plan.remote (remote) ->
  remote.log 'Move folder to root'
  remote.sudo 'cp -R /tmp/' + tmpDir + ' ~', user: username
  remote.rm '-rf /tmp/' + tmpDir
  remote.log 'Install dependencies'
  remote.sudo 'npm --production --prefix ~/' + tmpDir + ' install ~/' + tmpDir, user: username
  remote.log 'Reload application'
  remote.sudo 'ln -snf ~/' + tmpDir + ' ~/' + appName, user: username
  remote.exec 'forever stop ~/' + appName + '/' + startFile, failsafe: true
  remote.exec 'forever start ~/' + appName + '/' + startFile
  return
