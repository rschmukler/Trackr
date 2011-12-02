module TrackingLib
  class UPS
    def initalize()
      
    end

    def track(tracking_number)
      tracking_number = "874226648206"
      @events = []
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'

      page = agent.get "http://www.fedex.com/Tracking/Detail?ftc_start_url=&backTo=&totalPieceNum=&cntry_code=us&pieceNum=&language=english&template_type=print&selectedTimeZone=localScanTime&trackNum=" + tracking_number
      JSON.parse(page.body.scan(/detailInfoObject = .*;/).first[19..-2])
      page.search("form[name='sortForm'] div.tableContentsRows > div").each do |row|
        row = row.search("div");
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
