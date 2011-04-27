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

Client = (require "mysql").Client
syslog = require "./syslog"


# Prepend a zero to "x".  Poor man's sprintf "%02d"
format_number = (x, lim = 10) -> if x < lim then "0#{x}" else x

ymd = (time, sep = "-") ->
    (format_number(x) for x in [ time.getFullYear(), time.getMonth() + 1, time.getDate() ]).join sep

hms = (time, sep = ":") ->
    (format_number(x) for x in [ time.getHours(), time.getMinutes(), time.getSeconds() ]).join sep

dts = (time) -> ymd(time) + " " + hms(time)



class Storage
    constructor: (options) ->
        options.database ?= "syslog"

        @client = new Client options


    establish_connection: ->
        console.log "Attempting connection to mysql"
        @client.connect( (err) ->
            return unless err
            console.log "Received error '#{error}' while connecting"
        )


    create_table: (date) ->
        console.log "Creating table #{date}"

        severity = ("'#{x}'" for x in syslog.SEVERITY_NAMES).join(",")
        facility = ("'#{x}'" for x in syslog.FACILITY_NAMES).join(",")

        @client.query """
        CREATE TABLE `#{date}` (
            id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
            reported_at     DATETIME NOT NULL, -- datetime reported by device
            received_at     DATETIME NOT NULL,
            severity        ENUM(#{severity}) NOT NULL,
            facility        ENUM(#{facility}) NOT NULL,
            address         INT UNSIGNED NOT NULL,
            hostname        VARCHAR(64) NOT NULL,
            message         TEXT NOT NULL,

            INDEX (reported_at),
            INDEX (address)
        )
        """


    record: (syslog, rinfo, received_at = new Date()) ->
        sql = "INSERT INTO `#{ymd(syslog.time)}` (reported_at, received_at, address, hostname, severity, facility, message) VALUES (?, ?, INET_ATON(?), ?, ?, ?, ?)"
        params = [
            dts(syslog.time),
            dts(received_at),
            rinfo.address,
            syslog.hostname or "[unknown]",
            syslog.severity_to_str(),
            syslog.facility_to_str(),
            syslog.message
        ]

        @establish_connection() unless @client.connected
        @client.query(
            sql,
            params,
            (err) => 
                return unless err

                if m = /Table 'syslog.([\d-]+)' doesn't exist/.exec(err)
                    @create_table(m[1])
                    @record(syslog, rinfo, received_at)
        )


exports.Storage = Storage
