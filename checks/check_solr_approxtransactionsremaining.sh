#!/bin/bash
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

count=`/usr/local/nagios/libexec/nrpe_local/check_solr alfresco approxtransactionsremaining localhost`
critical=150
warning=100
if [ $(echo $count | grep -e "[0-9]") ]
then
  if [ $count -ge $warning ]
  then
    if [ $count -ge $critical ]
    then
      echo -e "CRITICAL :: ApproxTransactionsRemaining count is $count |'count'=$count;$warning;$critical;;"
      exit 2
    else
      echo -e "WARNING :: ApproxTransactionsRemaining count is $count |'count'=$count;$warning;$critical;;"
      exit 1
    fi
  else
    echo -e "OK :: ApproxTransactionsRemaining count is $count |'count'=$count;$warning;$critical;;"
    exit 0
  fi
else
  echo -e "UNKNOWN :: ApproxTransactionsRemaining count is $count"
  exit 3

fi
exit $?
