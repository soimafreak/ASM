#!/usr/bin/ruby
#################################################################
#
#   ASM - Alfresco Solr Monitor
#
#   Author:         Matthew Smith <soimafreak@gmail.com>
#   Site:           https://github.com/soimafreak/ASM
#   Purpose:        Gather Reporting information from solr SUMMARY report for monitoring by nagios type systems 
#   Date:           12th November 2012
#   Explination:    Alfresco Solr Monitor (ASM) is built using the SUMMARY report in Solr that has been extended by Alfresco so it can
#                   report on the health of the indexes and aid with monitoring Solr
#
#   Copyright:      Copyright (C) 2012, Matthew Smith
#   License:
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#################################################################

time=`/usr/local/nagios/libexec/nrpe_local/check_solr alfresco meandoctrans localhost`.to_f
critical=0.9
warning=0.5
if (time.is_a? Float)
  if ( time >= warning )
    if (time >= critical )
      puts "CRITICAL :: Mean Doc Transform time is #{time}|'time'=#{time};#{warning};#{critical};;"
      exit 2
    else
      puts "WARNING :: Mean Doc Transform time is #{time}|'time'=#{time};#{warning};#{critical};;"
      exit 1
    end
  else
    puts "OK :: Mean Doc Transform time is #{time}|'time'=#{time};#{warning};#{critical};;"
    exit 0
  end
else
  puts "UNKNOWN :: Mean Doc Transform time is #{time}"
  exit 3
end
