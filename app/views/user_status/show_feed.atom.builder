xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Redmine Latest Statuses"
    xml.description "Latest updates from redmine status plugin"
    xml.link url_for(:action => :index)
    
    for status in @statuses
      xml.item do
        xml.title "Update for #{status.user.name} @ #{status.created_at.strftime("%A %b %d - %I:%M %p")}"
        xml.description "#{status}"
        xml.pubDate status.created_at.to_s(:rfc822)
        xml.guid status.id
      end
    end
  end
end