module TrackingLib
  class Fedex
    def initalize()
      
    end

    def track(tracking_number)
      tracking_number = "874226648206"

      @events = []
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'

      page = agent.get "http://www.fedex.com/Tracking/Detail?ftc_start_url=&backTo=&totalPieceNum=&cntry_code=us&pieceNum=&language=english&template_type=print&selectedTimeZone=localScanTime&trackNum=" + tracking_number
      
      #Update package dates
      
      page.body.scan(/estimatedDeliveryDate = ".*";/).first[25..-3]
      page.body.scan(/deliveryDateTime = ".*";/).first[20..-3]
      
      track_json = JSON(page.body.scan(/detailInfoObject = .*;/).first[19..-2])
      track_json["scans"].each do |row|
        location = row["scanLocation"].split(/, /)
        @events << {
          :status => row["scanStatus"],
          :date => get_date(row["scanDate"] + "," + row["scanTime"]),
          :city => location[0],
          :state => location[1]
        }
      end
      pp @events
    end
    
    def updateEstimated
      package = Package.where(:tracking_number => tracking_number).first
      package.estimated_delivery_date = estimated_delivery_date.to_date
    end
    
    def updateDelivered
      
      
      
var estimatedDeliveryDate = "";
var deliveryDateTime = "Jul 29, 2011 11:49 AM";
    end
    
    def status
      @events.last.status
    end
    
    def events
      @events
    end
    
    private
    def get_date(date_str)
      DateTime.strptime(date_str, '%h %d %Y,%I:%M %p')
    end
  end
end
