################################################################################
# Create channels
################################################################################
feeds = [
  {
    title: 'Reuters | All Topics',
    scraping_content_selector: '#main-content p',
    url: 'https://www.reutersagency.com/feed/?taxonomy=best-topics&post_type=best'
  },
  {
    title: 'Christian Science Monitor | All',
    scraping_content_selector: '#story-content-bound p',
    url: 'https://rss.csmonitor.com/feeds/all'
  },
  {
    title: 'NPR | News',
    scraping_content_selector: 'article.story p',
    url: 'https://feeds.npr.org/1001/rss.xml'
  },
  {
    title: 'BBC | Top Stories',
    scraping_content_selector: 'p',
    url: 'http://feeds.bbci.co.uk/news/rss.xml'
  },
  {
    title: 'USA Today | Top Stories',
    scraping_content_selector: 'p',
    url: 'http://rssfeeds.usatoday.com/usatoday-NewsTopStories'
  },
  {
    title: 'The Guardian | US',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/us/rss'
  }
]

feeds.each {|feed| Channel.find_or_create_by(feed) }
