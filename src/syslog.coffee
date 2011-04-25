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

# Regex taken from Net::Syslogd http://search.cpan.org/~vinsworld/Net-Syslogd/
syslogre = /<(\d{1,3})>[\d{1,}: \*]*((?:[JFMASONDjfmasond]\w\w) {1,2}(?:\d+)(?: \d{4})* (?:\d{2}:\d{2}:\d{2}[\.\d{1,3}]*)(?: [A-Z]{1,3})*)?:*\s*(?:((?:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|(?:[a-zA-Z\-]+)) )?(.*)/

MONTHS = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]

SEVERITY = [ "EMERG", "ALERT", "CRIT", "ERR", "WARNING", "NOTICE", "INFO", "DEBUG" ]
FACILITY = [ "KERN", "USER", "MAIL", "DAEMON", "AUTH", "SYSLOG", "LPR", "NEWS", "UUCP", "CRON", "AUTHPRIV", "FTP", "NTP", "AUDIT", "ALERT", "CLOCK", "LOCAL0", "LOCAL1", "LOCAL2", "LOCAL3", "LOCAL4", "LOCAL5", "LOCAL6", "LOCAL7" ]


# TODO: If the time is missing, use today's date.  See the Net::Syslogd
# documentation about potential packets and how the dates are formatted.
#
# TODO: Handle invalid dates.  Need to decide whether an invalid date
# should be rewritten with today's date or the packet dropped.
parse_time_string = (str) ->
    new Date()


class SyslogPacket
    constructor: (buffer) ->
        try
            [ raw, @priority, time, @hostname, @message ] = syslogre.exec buffer.toString 'ascii'
        catch error
            throw "could not parse incoming packet"

        @severity = @priority % 8
        @facility = (@priority - @severity) / 8
        @time     = parse_time_string time

    severity_to_str: -> SEVERITY[@severity]
    facility_to_str: -> FACILITY[@facility]




exports.parse = (buffer) -> new SyslogPacket buffer
exports.SEVERITY_NAMES = SEVERITY
exports.FACILITY_NAMES = FACILITY
