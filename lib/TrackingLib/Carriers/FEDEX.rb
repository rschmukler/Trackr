module TrackingLib
  class FEDEX
    def initalize()
      
    end

    def track(tracking_number)
	  tracking_number = "874226648206"
      @events = []
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      page = agent.get "http://www.fedex.com/Tracking?language=english&cntry_code=us&tracknumbers=tracking_number.action"
      page.search("#detailTravelHistory")[1..-1].each do |row|
        row = row.search("td");
        location = row[0].text().gsub!(/\n| |\t/, "").split(/,/)
        @events << {
          :status => row[3].text().gsub!(/\n| |\t/, ""),
          :date => row[1].text().gsub!(/\n| |\t/, "")+","+row[2].text().gsub!(/\n| |\t/, ""),
          :city => location[0],
          :state => location[1]
        }
      end
      
    end
    
    def status
      @events.last.status
    end
    
    def events
      @events
    end
    
    private
    def get_date(date_str)
      if(date_str =~ /am|pm/)
        return Date.strptime(date_str, '%h %d, %Y, %I:%M %p')
      else
        return Date.strptime(date_str, '%h %d, %Y')
      end
    end
  end
end
