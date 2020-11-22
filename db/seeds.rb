################################################################################
# Create channels
################################################################################
feeds = [
  {
    title: 'Reuters | All Topics',
    url: 'https://www.reutersagency.com/feed/?taxonomy=best-topics&post_type=best'
  },
  {
    title: 'Christian Science Monitor | All',
    url: 'https://rss.csmonitor.com/feeds/all'
  },
  {
    title: 'NPR | News',
    url: 'https://feeds.npr.org/1001/rss.xml'
  }
]

feeds.each {|feed| Channel.find_or_create_by(feed) }
