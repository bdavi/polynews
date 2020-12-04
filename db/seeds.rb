################################################################################
# Create Categories
################################################################################
categories = [
  { title: 'Headlines', slug: 'headlines', sort_order: '0' },
  { title: 'U.S.', slug: 'us', sort_order: '1' },
  { title: 'International', slug: 'international', sort_order: '2' },
  { title: 'Business', slug: 'business', sort_order: '3' },
  { title: 'Technology', slug: 'technology', sort_order: '4' },
  { title: 'Sports', slug: 'sports', sort_order: '5' },
  { title: 'Science', slug: 'science', sort_order: '6' },
]

categories.each do |category_attrs|
  category = Category.find_or_initialize_by(title: category_attrs[:title])
  category.update(category_attrs)
end


################################################################################
# Create channels
################################################################################
feeds = [
  {
    title: 'Axios | Top Stories',
    scraping_content_selector: nil,
    url: 'https://api.axios.com/feed/top',
    use_scraper: false,
    category: Category.find_by(slug: 'headlines')
  },
  {
    title: 'Axios | Politics & Policy',
    scraping_content_selector: nil,
    url: 'https://api.axios.com/feed/politics-policy',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'Axios | Technology',
    scraping_content_selector: nil,
    url: 'https://api.axios.com/feed/technology',
    use_scraper: false,
    category: Category.find_by(slug: 'technology')
  },
  {
    title: 'Axios | World',
    scraping_content_selector: nil,
    url: 'https://api.axios.com/feed/world',
    use_scraper: false,
    category: Category.find_by(slug: 'international')
  },
  {
    title: 'Axios | Economics & Business',
    scraping_content_selector: nil,
    url: 'https://api.axios.com/feed/economy-business',
    use_scraper: false,
    category: Category.find_by(slug: 'business')
  },
  {
    title: 'Axios | Sports',
    scraping_content_selector: nil,
    url: 'https://api.axios.com/feed/sports',
    use_scraper: false,
    category: Category.find_by(slug: 'sports')
  },
  {
    title: 'Axios | Science',
    scraping_content_selector: nil,
    url: 'https://api.axios.com/feed/science',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'BBC | Top Stories',
    scraping_content_selector: 'article p',
    url: 'http://feeds.bbci.co.uk/news/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'headlines')
  },
  {
    title: 'BBC | World',
    scraping_content_selector: 'article p',
    url: 'http://feeds.bbci.co.uk/world/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'international')
  },
  {
    title: 'BBC | Business',
    scraping_content_selector: 'article p',
    url: 'http://feeds.bbci.co.uk/business/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'business')
  },
  {
    title: 'BBC | Science & Environment',
    scraping_content_selector: 'article p',
    url: 'http://feeds.bbci.co.uk/science_and_environment/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'BBC | Technology',
    scraping_content_selector: 'article p',
    url: 'http://feeds.bbci.co.uk/technology/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'technology')
  },
  {
    title: 'Christian Science Monitor | All',
    scraping_content_selector: '#story-content-bound p',
    url: 'https://rss.csmonitor.com/feeds/all',
    use_scraper: true,
    category: Category.find_by(slug: 'headlines')
  },
  {
    title: 'NPR | News',
    scraping_content_selector: 'article.story p',
    url: 'https://feeds.npr.org/1001/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'headlines')
  },
  {
    title: 'NPR | Business',
    scraping_content_selector: 'article.story p',
    url: 'https://feeds.npr.org/1019/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'business')
  },
  {
    title: 'NPR | Economy',
    scraping_content_selector: 'article.story p',
    url: 'https://feeds.npr.org/1017/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'business')
  },
  {
    title: 'NPR | Science',
    scraping_content_selector: 'article.story p',
    url: 'https://feeds.npr.org/1007/rss.xml',
    use_scraper: true,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'Reuters | All Topics',
    scraping_content_selector: '#main-content p',
    url: 'https://www.reutersagency.com/feed/?taxonomy=best-topics&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'headlines')
  },
  {
    title: 'Reuters | Business & Finance',
    scraping_content_selector: '#main-content p',
    url: 'https://www.reutersagency.com/feed/?best-topics=business-finance&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'business')
  },
  {
    title: 'Reuters | Tech',
    scraping_content_selector: '#main-content p',
    url: 'https://www.reutersagency.com/feed/?best-topics=tech&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'technology')
  },
  {
    title: 'Reuters | Environment',
    scraping_content_selector: '#main-content p',
    url: 'https://www.reutersagency.com/feed/?best-topics=environment&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'The Hill | Most Popular',
    scraping_content_selector: 'article p',
    url: 'http://thehill.com/rss/syndicator/19110',
    use_scraper: true,
    category: Category.find_by(slug: 'headlines')
  },
]

feeds.each do |feed|
  channel = Channel.find_or_initialize_by(title: feed[:title])
  channel.update(feed)
end
