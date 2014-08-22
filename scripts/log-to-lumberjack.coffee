# Description:
#   Logs messages to a Lumberjack instance
#
# Dependencies:
#
#
# Configuration:
#   HUBOT_LUMBERJACK_URL
#   HUBOT_LUMBERJACK_SECRET
#
# Commands:
#   None
#
# Author:
#   qrohlf

module.exports = (robot) ->

  robot.hear /.*/i, (msg) ->
    data = JSON.stringify({
      room: {
        name: msg.message.room
      },
      message: {
        sender: msg.message.user.name
        body: msg.message.text
        timestamp: Date()
      },
      secret: process.env.HUBOT_LUMBERJACK_SECRET
    });
    robot.http(process.env.HUBOT_LUMBERJACK_URL)
      .header('content-type', 'application/json')
      .post(data) (err, res, body) ->
        if err
          robot.logger.error "Error pushing to lumberjack: #{err}"
          robot.logger.error body
        if res.statusCode isnt 201
          robot.logger.error "Lumberjack returned status code #{res.statusCode} when trying to log:"
          robot.logger.error body
