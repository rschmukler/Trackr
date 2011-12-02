module TrackingLib
  class UPS
    def initalize()
      
    end

    def track(tracking_number)
      #tracking_number = "1Z2080X00308970279"
      @events = []
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      page = agent.get "http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_us&InquiryNumber1=" + tracking_number + "&track.x=0&track.y=0"
      page.search(".module3 table tr")[1..-1].each do |row|
        row = row.search("td");
        location = row[0].text().gsub!(/\n| |\t/, "").split(/,/)
        @events << {
          :status => row[3].text().gsub!(/\n| |\t/, ""),
          :date => get_date(row[1].text().gsub!(/\n| |\t/, "")+","+row[2].text().gsub!(/\n| |\t/, "")),
          :city => location[0],
          :state => location[1]
        }
      end
      #pp @events
    end
    
    def update_estimated
      @package.estimated_delivery_date = @estimated_delivery_date.to_date
      @package.save
    end
    
    def delivered_at
      @package.delivered_at = @delivered_at.to_date
      @package.save
    end
    
    def status
      @events.last.status
    end
    
    def events
      @events
    end
    
    private
    def get_date(date_str)
      DateTime.strptime(date_str, '%m/%d/%Y,%I:%M%p')
    end
  end
end
