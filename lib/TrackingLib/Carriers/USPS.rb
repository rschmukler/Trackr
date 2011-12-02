module TrackingLib
  class USPS
    def initalize()
      
    end

    def track(tracking_number)
      @events = []
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'

      page = agent.get "https://tools.usps.com/go/TrackConfirmAction.action"
      tracking_form = page.form_with :name => "TrackConfirmAction2"
      tracking_form.field_with(:name => "tLabels").value = tracking_number

      results = agent.submit(tracking_form)
      results.search("#tc-hits tr").each do |row|
        #location = row.search(".td-status > p").text().split(//)
        puts row.search(".td-status > p").text();
        @events << {
          :status => row.search(".td-status > p").text(),
          :date => Date.strptime(row.search(".td-status > p").text(), '%h %d, %Y,')
        }
     
      end
    end
    
    def status
      
    end
    
    def events
      @events
    end
    
  end
end
