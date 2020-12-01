################################################################################
# Create Categories
################################################################################
categories = %w(
  Headlines
  U.S.
  International
  Business
  Technology
  Sports
  Science
  Culture
  Long\ Reads
)

categories.each_with_index do |category, i|
  Category.find_or_create_by(title: category, sort_order: i)
end


################################################################################
# Create channels
################################################################################
feeds = [
  {
    title: 'Axios | Top Stories',
    scraping_content_selector: nil,
    url: 'https://api.axios.com/feed/health-care',
    use_scraper: false,
    category: Category.find_by(title: 'Headlines')
  },
  {
    title: 'BBC | Top Stories',
    scraping_content_selector: 'article p',
    url: 'http://feeds.bbci.co.uk/news/rss.xml',
    use_scraper: true,
    category: Category.find_by(title: 'Headlines')
  },
  {
    title: 'Christian Science Monitor | All',
    scraping_content_selector: '#story-content-bound p',
    url: 'https://rss.csmonitor.com/feeds/all',
    use_scraper: true,
    category: Category.find_by(title: 'Headlines')
  },
  {
    title: 'NPR | News',
    scraping_content_selector: 'article.story p',
    url: 'https://feeds.npr.org/1001/rss.xml',
    use_scraper: true,
    category: Category.find_by(title: 'Headlines')
  },
  {
    title: 'Reuters | All Topics',
    scraping_content_selector: '#main-content p',
    url: 'https://www.reutersagency.com/feed/?taxonomy=best-topics&post_type=best',
    use_scraper: false,
    category: Category.find_by(title: 'Headlines')
  },
  {
    title: 'The Hill | Most Popular',
    scraping_content_selector: 'article p',
    url: 'http://thehill.com/rss/syndicator/19110',
    use_scraper: true,
    category: Category.find_by(title: 'Headlines')
  },
  {
    title: 'Time Magazine | Current & Breaking News',
    scraping_content_selector: '#article-body p',
    url: 'https://time.com/feed/',
    use_scraper: false,
    category: Category.find_by(title: 'Headlines')
  }
]

feeds.each do |feed|
  channel = Channel.find_or_initialize_by(title: feed[:title])
  channel.update(feed)
end
