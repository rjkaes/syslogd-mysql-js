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

Server = (require "./server").Server

SYSLOG_PORT = 514
server = new Server(SYSLOG_PORT)
server.startListening()


