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

  log_message = (room, user, body) ->
    data = JSON.stringify({
      room: {
        name: room
      },
      message: {
        sender: user,
        body: body,
        timestamp: Date()
      },
      secret: process.env.HUBOT_LUMBERJACK_SECRET
    })

    robot.http(process.env.HUBOT_LUMBERJACK_URL)
      .header('content-type', 'application/json')
      .post(data) (err, res, body) ->
        robot.logger.info "watwatwat"
        if err
          robot.logger.error "Error pushing to lumberjack: #{err}"
          robot.logger.error body
        else if res.statusCode isnt 201
          robot.logger.error "Lumberjack returned status code #{res.statusCode} when trying to log:"
          robot.logger.error body

  robot.hear /.*/i, (msg) ->
    # return unless msg.message.room
    log_message(msg.message.room, msg.message.user.name, msg.message.text)

  # Override send methods in the Response prototype so that we can log Hubot's replies
  # This is kind of evil, but there doesn't appear to be a better way
  log_response = (room, strings...) ->
    for string in strings
      log_message(room, robot.name, string)

  response_orig =
    send: robot.Response.prototype.send
    reply: robot.Response.prototype.reply

  robot.Response.prototype.send = (strings...) ->
    log_response @message.user.room, strings...
    response_orig.send.call @, strings...

  robot.Response.prototype.reply = (strings...) ->
    log_response @message.user.room, strings...
    response_orig.reply.call @, strings...
