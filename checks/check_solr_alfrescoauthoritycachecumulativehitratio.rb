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

$:.unshift File.expand_path("../", __FILE__)
require 'lib/solr_dao.rb'
solr_results=SolrDAO.new("http://localhost:8080/solr/admin/cores?action=SUMMARY")
cumulative_hitratio=solr_results.get_alfrescoAuthorityCache_cumulative_hitratio("alfresco").to_f
cumulative_lookups=solr_results.get_alfrescoAuthorityCache_cumulative_lookups("alfresco").to_i
#Hit ratio is an inverse, 1.0 is perfect 0.1 is crap, and can be ignored if there is less than 100 lookups
inverse=(1.0-cumulative_hitratio)
critical=0.8
warning=0.7
if (inverse.is_a? Float)
  if ( cumulative_lookups >= 100 )
    if ( inverse >= warning )
      if (inverse >= critical )
        puts "CRITICAL :: AlfrescoAuthorityCache cumulative_hitratio is #{cumulative_hitratio}|'cumulative_hitratio'=#{cumulative_hitratio};#{warning};#{critical};;"
        exit 2
      else
        puts "WARNING :: AlfrescoAuthorityCache cumulative_hitratio is #{cumulative_hitratio}|'cumulative_hitratio'=#{cumulative_hitratio};#{warning};#{critical};;"
        exit 1
      end
    else
      puts "OK :: AlfrescoAuthorityCache cumulative_hitratio is #{cumulative_hitratio}|'cumulative_hitratio'=#{cumulative_hitratio};#{warning};#{critical};;"
      exit 0
    end
  else
    puts "OK :: AlfrescoAuthorityCache cumulative_hitratio is #{cumulative_hitratio}|'cumulative_hitratio'=#{cumulative_hitratio};#{warning};#{critical};;"
    exit 0
  end
else
  puts "UNKNOWN :: AlfrescoAuthorityCache cumulative_hitratio is #{cumulative_hitratio}"
  exit 3
end
