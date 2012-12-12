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
# Solr Metric gatherer
# This should be roughtly in setp with the Metrics solr_dao

require 'rubygems'
require "crack"
require 'open-uri'

class SolrDAO

  def initialize (url, result_file="/tmp/solr_results", cache_age="300")

    #Cache the results for 5 mins
    if File.exists?(result_file)
      if (clearcache(result_file,cache_age))
        #remove file
        File.delete(result_file)
        #Populate cached file
        @solr_hash = load_cache(result_file,url)
      else
        #Just load it
        @solr_hash=load_cache(result_file,url)
      end
    else
      #No file so use cache
      @solr_hash = load_cache(result_file,url)
    end
  end

  def get_lag(index)
    lag = @solr_hash["Summary"][index]["TX Lag"]
    regex= Regexp.new(/\d*/)
    lag_number = regex.match(lag)
    return lag_number
  end

  def get_alfresco_node_in_index(index)
    return @solr_hash["Summary"][index]["Alfresco Nodes in Index"]
  end
  
  def get_num_docs(index)
    return @solr_hash["Summary"][index]["Searcher"]["numDocs"]
  end
  
  def get_alfresco_avgTimePerRequest(index)
    return @solr_hash["Summary"][index]["/alfresco"]["avgTimePerRequest"]
  end

  def get_afts_avgTimePerRequest(index)
    return @solr_hash["Summary"][index]["/afts"]["avgTimePerRequest"]
  end

  def get_cmis_avgTimePerRequest(index)
    return @solr_hash["Summary"][index]["/cmis"]["avgTimePerRequest"]
  end

  def get_mean_doc_transformation_time(index)
    return @solr_hash["Summary"][index]["Doc Transformation time (ms)"]["Mean"]
  end

  def get_approxTransactionsRemaining(index)
    return @solr_hash["Summary"][index]["Approx transactions remaining"]
  end
  
  def get_approxChangeSetsRemaining(index)
    return @solr_hash["Summary"][index]["Approx change sets remaining"]
  end
  
  def get_queryResultCache_cumulative_lookups(index)
    return @solr_hash["Summary"][index]["/queryResultCache"]["cumulative_lookups"]
  end
  
  def get_queryResultCache_lookups(index)
    return @solr_hash["Summary"][index]["/queryResultCache"]["lookups"]
  end
  
  def get_queryResultCache_cumulative_hitratio(index)
    return @solr_hash["Summary"][index]["/queryResultCache"]["cumulative_hitratio"]
  end
  
  def get_queryResultCache_hitratio(index)
    return @solr_hash["Summary"][index]["/queryResultCache"]["hitratio"]
  end
  
  def get_filterCache_cumulative_lookups(index)
    return @solr_hash["Summary"][index]["/filterCache"]["cumulative_lookups"]
  end
  
  def get_filterCache_lookups(index)
    return @solr_hash["Summary"][index]["/filterCache"]["lookups"]
  end
  
  def get_filterCache_cumulative_hitratio(index)
    return @solr_hash["Summary"][index]["/filterCache"]["cumulative_hitratio"]
  end
  
  def get_filterCache_hitratio(index)
    return @solr_hash["Summary"][index]["/filterCache"]["hitratio"]
  end
  
  def get_alfrescoPathCache_cumulative_lookups(index)
    return @solr_hash["Summary"][index]["/alfrescoPathCache"]["cumulative_lookups"]
  end
  
  def get_alfrescoPathCache_lookups(index)
    return @solr_hash["Summary"][index]["/alfrescoPathCache"]["lookups"]
  end
  
  def get_alfrescoPathCache_cumulative_hitratio(index)
    return @solr_hash["Summary"][index]["/alfrescoPathCache"]["cumulative_hitratio"]
  end
  
  def get_alfrescoPathCache_hitratio(index)
    return @solr_hash["Summary"][index]["/alfrescoPathCache"]["hitratio"]
  end
  
  def get_alfrescoAuthorityCache_cumulative_lookups(index)
    return @solr_hash["Summary"][index]["/alfrescoAuthorityCache"]["cumulative_lookups"]
  end
  
  def get_alfrescoAuthorityCache_lookups(index)
    return @solr_hash["Summary"][index]["/alfrescoAuthorityCache"]["lookups"]
  end
  
  def get_alfrescoAuthorityCache_cumulative_hitratio(index)
    return @solr_hash["Summary"][index]["/alfrescoAuthorityCache"]["cumulative_hitratio"]
  end
  
  def get_alfrescoAuthorityCache_hitratio(index)
    return @solr_hash["Summary"][index]["/alfrescoAuthorityCache"]["hitratio"]
  end
  
  def get_queryResultCache_warmupTime(index)
    return @solr_hash["Summary"][index]["/queryResultCache"]["warmupTime"]
  end
  
  def get_filterCache_warmupTime(index)
    return @solr_hash["Summary"][index]["/filterCache"]["warmupTime"]
  end
  
  def get_alfrescoPathCache_warmupTime(index)
    return @solr_hash["Summary"][index]["/alfrescoPathCache"]["warmupTime"]
  end
  
  def get_alfrescoAuthorityCache_warmupTime(index)
    return @solr_hash["Summary"][index]["/alfrescoAuthorityCache"]["warmupTime"]
  end
  
  private
  def get_metrics(url)
    url += "&wt=json"
    response = open(url).read
    # if the hash has 'Error' as a key, we raise an error
    return response
  end
  
  def load_cache(file,url)
    if File.exists?(file)
      if File.readable?(file)
        if (File.size(file) >0)
            json= File.read(file)
            # Convert to hash
            result_hash = {}
            result_hash = Crack::JSON.parse(json)
            #puts "Loading cache"
            return result_hash
        else
          puts "file has no content"
        end
      else
        puts "file is not readable: #{file}" 
      end
    else
      #puts "Cache file old or non existant, creating a new one"
      hash = Hash.new
      hash = get_metrics(url)
      f = File.new(file,"w")
      f.write(hash)
      f.close
      json= File.read(file)
      # Convert to hash
      result_hash = {}
      result_hash = Crack::JSON.parse(json)
      return result_hash
    end
  end

  def clearcache(file,cache_time)

    file_time=File.mtime(file).to_i
    cache_time=(Time.now - cache_time.to_i).to_i

    if (cache_time >= file_time)
      return true
    else
      return false
    end
  end


end # End of class
