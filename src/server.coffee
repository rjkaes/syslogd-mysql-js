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

util   = require "util"
dgram  = require "dgram"

syslog  = require "./syslog"
Storage = (require "./storage").Storage

SYSLOG_PORT = 514

storage = new Storage { user: "root", password: "" }

server = dgram.createSocket "udp4"
server.on "message", (msg, rinfo) ->
    try
        storage.record (syslog.parse msg), rinfo
    catch error
        util.log "Invalid datagram received from #{rinfo.address}:#{rinfo.port} (#{error})"

server.bind SYSLOG_PORT
