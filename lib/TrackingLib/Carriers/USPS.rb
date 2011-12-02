module TrackingLib
  class USPS
    def initalize()
      
    end
    
    def track(tracking_number)
      #tracking_number = "9102901001298281042638"
      @events = []
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      page = agent.get "https://tools.usps.com/go/TrackConfirmAction.action"
      tracking_form = page.form_with :name => "TrackConfirmAction2"
      tracking_form.field_with(:name => "tLabels").value = tracking_number
      results = agent.submit(tracking_form)
      results.search("#tc-hits tbody tr").each do |row|
        array = row.text().force_encoding('ASCII-8BIT').gsub(/\xC2\xA0/, " ").gsub(/\r|\n|\t/," ").gsub(/#{tracking_number}|Result \d|Package Services/, '').strip().split(/   +/)
        location = array[2].split(/ /).map{|text| text.capitalize}
        @events << {
          :status => array[0],
          :date => get_date(array[1]),
          :city => location[0],
          :state => location[1],
          :zip => location[2]
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
