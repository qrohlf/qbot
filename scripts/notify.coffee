# Description:
#   Notify qrohlf if he is mentioned in chat


module.exports = (robot) ->
  util = require('util');
  Pushover = require("node-pushover")
  push = new Pushover(
    token: process.env.PUSHOVER_APP_TOKEN
    user: process.env.PUSHOVER_USER
  )


  robot.hear /qrohlf/i, (msg) ->
    push.send "Mentioned in "+msg.message.room, msg.message.text, (err, res) ->
      if err
        robot.logger.error "Error sending pushover notification:"
        robot.logger.error err
        robot.logger.error err.stack
      else
        robot.logger.info "Pushover notification sent successfully"
        robot.logger.info res
      return
