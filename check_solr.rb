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


#
# Check Solr is a wrapper to solr DAO
#
$:.unshift File.expand_path("../", __FILE__)
require 'lib/solr_dao.rb'
index=ARGV[0]
check=ARGV[1]
host=ARGV[2]
solr_results=SolrDAO.new("http://#{host}:8080/solr/admin/cores?action=SUMMARY")

case check
  when "lag"
    puts "#{solr_results.get_lag(index)}"
  when "numdocs"
    puts "#{solr_results.get_num_docs(index)}"
  when "alfrescoavg"
    puts "#{solr_results.get_alfresco_avgTimePerRequest(index)}"
  when "meandoctrans"
    puts "#{solr_results.get_mean_doc_transformation_time(index)}"
  when "nodesinindex"
    puts "#{solr_results.get_alfresco_node_in_index(index)}"
  when "aftsavg"
    puts "#{solr_results.get_afts_avgTimePerRequest(index)}"
  when "cmisavg"
    puts "#{solr_results.get_cmis_avgTimePerRequest(index)}"
  when "querycachewarmup"
    puts "#{solr_results.get_queryResultCache_warmupTime(index)}"
  when "filtercachewarmup"
    puts "#{solr_results.get_filterCache_warmupTime(index)}"
end
