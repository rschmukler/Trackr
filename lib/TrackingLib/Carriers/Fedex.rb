module TrackingLib
  class Fedex
    def initalize()
      
    end

    def track(tracking_number)
      #tracking_number = "874226648206"
      @tracking_number = tracking_number
      @package = Package.where(:tracking_number => @tracking_number).first
      @events = []
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'

      page = agent.get "http://www.fedex.com/Tracking/Detail?ftc_start_url=&backTo=&totalPieceNum=&cntry_code=us&pieceNum=&language=english&template_type=print&selectedTimeZone=localScanTime&trackNum=" + @tracking_number
      
      #Update package dates
      @estimated_delivery_date = page.body.scan(/estimatedDeliveryDate = ".*";/).first[25..-3]
      if not(@estimated_delivery_date.empty?)
        @estimated_delivery_date = get_date(@estimated_delivery_date)
        self.update_estimated
      end
      
      @delivered_at = page.body.scan(/deliveryDateTime = ".*";/).first[20..-3]
      if not(@delivered_at.empty?)
        @delivered_at = get_date(@delivered_at)
        self.delivered_at
      end
      
      track_json = JSON(page.body.scan(/detailInfoObject = .*;/).first[19..-2])
      
      @package.events.delete_all # Wipe old events
      track_json["scans"].each do |row|
        location = row["scanLocation"].split(/, /)
        @events << {
          :status => row["scanStatus"],
          :date_time => get_date(row["scanDate"] + " " + row["scanTime"]),
          :city => location[0],
          :state => location[1]
        }
        event = Event.new(
          :status => row["scanStatus"],
          :date_time => get_date(row["scanDate"] + " " + row["scanTime"]),
          :city => location[0],
          :state => location[1]
        )
        event.save
      end
    end
    
    def update_estimated
      @package.estimated_delivery_date = @estimated_delivery_date
      @package.save
    end
    
    def delivered_at
      @package.delivered_at = @delivered_at
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
      puts date_str
      DateTime.strptime(date_str, '%b %d, %Y %R %p')
    end
  end
end
