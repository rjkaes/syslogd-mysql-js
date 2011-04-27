###

  Copyright 2011 Robert James Kaes

  This file is part of syslogd-mysql-js.

  syslogd-mysql-js is free software: you can redistribute it and/or modify it
  under the terms of the GNU General Public License as published by the Free
  Software Foundation, either version 3 of the License, or (at your option) any
  later version.
  
  syslogd-mysql-js is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  You should have received a copy of the GNU General Public License along with
  syslogd-mysql-js.  If not, see <http://www.gnu.org/licenses/>.

###

util         = require "util"
dgram        = require "dgram"
EventEmitter = (require "events").EventEmitter
syslog       = require "./syslog"

DEFAULT_SYSLOG_PORT = 514

exports.Server = class Server extends EventEmitter
    constructor: (options = {}) ->
        @port = options.port ? DEFAULT_SYSLOG_PORT

        @udp = dgram.createSocket "udp4"
        @udp.on "message", (msg, rinfo) =>
            try
                @emit "syslog", (syslog.parse msg), rinfo
            catch error
                util.log "Invalid datagram received from #{rinfo.address}:#{rinfo.port} (#{error})"

    startListening: ->
        @udp.bind @port
