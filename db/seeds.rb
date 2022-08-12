################################################################################
# Create Categories
################################################################################
categories = [
  { title: 'U.S.', slug: 'us', sort_order: '1' },
  { title: 'World', slug: 'world', sort_order: '2' },
  { title: 'Economy', slug: 'economy', sort_order: '3' },
  { title: 'Tech', slug: 'tech', sort_order: '4' },
  { title: 'Sports', slug: 'sports', sort_order: '5' },
  { title: 'Science', slug: 'science', sort_order: '6' },
  { title: 'Politics', slug: 'politics', sort_order: '7' },
  { title: 'Long Form', slug: 'long_form', sort_order: '8' }
]

categories.each do |category_attrs|
  category = Category.find_or_initialize_by(slug: category_attrs[:slug])
  category.update(category_attrs)
end


################################################################################
# Create channels
################################################################################
feeds = [
  {
    title: 'The Economist | United States',
    scraping_content_selector: nil,
    url: 'https://www.economist.com/united-states/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'Boston Globe | United States',
    scraping_content_selector: nil,
    url: 'https://www.boston.com/tag/national-news/?feed=rss',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'NYT | US',
    scraping_content_selector: 'p',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/US.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'BBC | US',
    scraping_content_selector: 'p',
    url: 'http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'Christian Science Monitor | US',
    scraping_content_selector: 'p',
    url: 'http://rss.csmonitor.com/feeds/usa',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'The Guardian | US News',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/us-news/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'Washington Post | National',
    scraping_content_selector: 'p',
    url: 'http://feeds.washingtonpost.com/rss/national?itid=lk_inline_manual_39',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'NPR | National',
    scraping_content_selector: 'p',
    url: 'https://feeds.npr.org/1003/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'Reuters | North America',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-regions=north-america&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'NBC News | US News',
    scraping_content_selector: 'p',
    url: 'http://feeds.nbcnews.com/nbcnews/public/us-news',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'CBS News | US News',
    scraping_content_selector: 'p',
    url: 'https://www.cbsnews.com/latest/rss/us',
    use_scraper: false,
    category: Category.find_by(slug: 'us')
  },
  {
    title: 'The Economist | Europe',
    scraping_content_selector: nil,
    url: 'https://www.economist.com/europe/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Economist | The Americas',
    scraping_content_selector: nil,
    url: 'https://www.economist.com/the-americas/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Economist | Middle East and Africa',
    scraping_content_selector: nil,
    url: 'https://www.economist.com/middle-east-and-africa/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Economist | Asia',
    scraping_content_selector: nil,
    url: 'https://www.economist.com/asia/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Economist | China',
    scraping_content_selector: nil,
    url: 'https://www.economist.com/china/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Boston Globe | World',
    scraping_content_selector: nil,
    url: 'https://www.boston.com/tag/world-news/?feed=rss',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'NYT | World',
    scraping_content_selector: 'p',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/World.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'BBC | World',
    scraping_content_selector: 'p',
    url: 'http://feeds.bbci.co.uk/news/world/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Christian Science Monitor | World',
    scraping_content_selector: 'p',
    url: 'http://rss.csmonitor.com/feeds/world',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Guardian | Europe',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/world/europe-news/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Guardian | Americas',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/world/americas/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Guardian | Asia',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/world/asia/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Guardian | Middle East',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/world/middleeast/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Guardian | Africa',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/world/africa/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Washington Post | World',
    scraping_content_selector: 'p',
    url: 'http://feeds.washingtonpost.com/rss/world?itid=lk_inline_manual_43',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'NPR | World',
    scraping_content_selector: 'p',
    url: 'https://feeds.npr.org/1004/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Reuters | Middle East',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-regions=middle-east&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Reuters | Africa',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-regions=africa&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Reuters | Europe',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-regions=europe&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Reuters | South America',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-regions=south-america&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Reuters | Asia',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-regions=asia&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'NBC News | World',
    scraping_content_selector: 'p',
    url: 'http://feeds.nbcnews.com/nbcnews/public/world',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'CBS News | World',
    scraping_content_selector: 'p',
    url: 'https://www.cbsnews.com/latest/rss/world',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'The Economist | Finance and Economics',
    scraping_content_selector: nil,
    url: 'https://www.economist.com/finance-and-economics/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'Boston Globe | Finance',
    scraping_content_selector: nil,
    url: 'https://www.boston.com/tag/finance/?feed=rss',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'NYT | Business',
    scraping_content_selector: 'p',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/Business.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'Christian Science Monitor | Business',
    scraping_content_selector: 'p',
    url: 'http://rss.csmonitor.com/feeds/wam',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'The Guardian | Business',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/us/business/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'Washington Post | Business',
    scraping_content_selector: 'p',
    url: 'http://feeds.washingtonpost.com/rss/business?itid=lk_inline_manual_44',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'NPR | Economy',
    scraping_content_selector: 'p',
    url: 'https://feeds.npr.org/1017/rss.xml ',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'Reuters | Business & Finance',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-topics=business-finance&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'NBC News | Business',
    scraping_content_selector: 'p',
    url: 'http://feeds.nbcnews.com/nbcnews/public/business',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'Boston Globe | Science',
    scraping_content_selector: nil,
    url: 'https://www.boston.com/tag/science/?feed=rss',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'NYT | Science',
    scraping_content_selector: 'p',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/Science.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'BBC | Science',
    scraping_content_selector: 'p',
    url: 'http://feeds.bbci.co.uk/news/science_and_environment/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'Christian Science Monitor | Science',
    scraping_content_selector: 'p',
    url: 'http://rss.csmonitor.com/feeds/science',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'The Guardian | Science',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/science/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'NPR | Science',
    scraping_content_selector: 'p',
    url: 'https://feeds.npr.org/1007/rss.xml ',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'NBC News | Science',
    scraping_content_selector: 'p',
    url: 'http://feeds.nbcnews.com/nbcnews/public/science',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'CBS News | Science',
    scraping_content_selector: 'p',
    url: 'https://www.cbsnews.com/latest/rss/science',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'The Economist | Science and Technology',
    scraping_content_selector: nil,
    url: 'https://www.economist.com/science-and-technology/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'Boston Globe | Technology',
    scraping_content_selector: nil,
    url: 'https://www.boston.com/tag/technology/?feed=rss',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'NYT | Technology',
    scraping_content_selector: 'p',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'BBC | Technology',
    scraping_content_selector: 'p',
    url: 'http://feeds.bbci.co.uk/news/technology/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'The Guardian | Technology',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/us/technology/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'Reuters | Tech',
    scraping_content_selector: '#main-content p',
    url: 'https://www.reutersagency.com/feed/?best-topics=tech&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'NBC News | Tech & Media',
    scraping_content_selector: 'p',
    url: 'http://feeds.nbcnews.com/nbcnews/public/tech',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'CBS News | Technology',
    scraping_content_selector: 'p',
    url: 'https://www.cbsnews.com/latest/rss/technology',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'NYT | Sports',
    scraping_content_selector: 'p',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/Sports.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'sports')
  },
  {
    title: 'The Guardian | Sport',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/us/sport/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'sports')
  },
  {
    title: 'Reuters | Sports',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-topics=sports&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'sports')
  },
  {
    title: 'ESPN | Top',
    scraping_content_selector: 'p',
    url: 'https://www.espn.com/espn/rss/news',
    use_scraper: false,
    category: Category.find_by(slug: 'sports')
  },
  {
    title: 'Boston Globe | Politics',
    scraping_content_selector: nil,
    url: 'https://www.boston.com/tag/politics/?feed=rss',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'NYT | Politics',
    scraping_content_selector: 'p',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/Politics.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'BBC | Politics',
    scraping_content_selector: 'p',
    url: 'http://feeds.bbci.co.uk/news/politics/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'Christian Science Monitor | Politics',
    scraping_content_selector: 'p',
    url: 'http://rss.csmonitor.com/feeds/politics',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'The Guardian | US Politics',
    scraping_content_selector: 'p',
    url: 'https://www.theguardian.com/us-news/us-politics/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'Washington Post | Politics',
    scraping_content_selector: 'p',
    url: 'http://feeds.washingtonpost.com/rss/politics?itid=lk_inline_manual_2',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'NPR | Politics',
    scraping_content_selector: 'p',
    url: 'https://feeds.npr.org/1014/rss.xml ',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'Reuters | Politics',
    scraping_content_selector: 'p',
    url: 'https://www.reutersagency.com/feed/?best-topics=political-general&post_type=best',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'NBC News | Politics',
    scraping_content_selector: 'p',
    url: 'http://feeds.nbcnews.com/nbcnews/public/politics',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'CBS News | Politics',
    scraping_content_selector: 'p',
    url: 'https://www.cbsnews.com/latest/rss/politics',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'Independent | Politics',
    scraping_content_selector: 'p',
    url: 'https://www.independent.co.uk/news/world/americas/us-politics/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'politics')
  },
  {
    title: 'Independent | World',
    scraping_content_selector: 'p',
    url: 'https://www.independent.co.uk/news/world/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'world')
  },
  {
    title: 'Independent | Business',
    scraping_content_selector: 'p',
    url: 'https://www.independent.co.uk/news/business/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'economy')
  },
  {
    title: 'Independent | Sports',
    scraping_content_selector: 'p',
    url: 'https://www.independent.co.uk/sport/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'sports')
  },
  {
    title: 'Discover | Technology',
    scraping_content_selector: 'p',
    url: 'http://feeds.feedburner.com/DiscoverTechnology',
    use_scraper: false,
    category: Category.find_by(slug: 'tech')
  },
  {
    title: 'Discover | Space',
    scraping_content_selector: 'p',
    url: 'http://feeds.feedburner.com/DiscoverSpace',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'Discover | Living World',
    scraping_content_selector: 'p',
    url: 'http://feeds.feedburner.com/DiscoverLivingWorld',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'Discover | Environment',
    scraping_content_selector: 'p',
    url: 'http://feeds.feedburner.com/DiscoverEnvironment',
    use_scraper: false,
    category: Category.find_by(slug: 'science')
  },
  {
    title: 'The Atlantic | Long Reads',
    scraping_content_selector: nil,
    url: 'https://www.theatlantic.com/feed/category/longreads/',
    use_scraper: false,
    category: Category.find_by(slug: 'long_form')
  },
  {
    title: 'NYT | Sunday Review',
    scraping_content_selector: nil,
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/sunday-review.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'long_form')
  },
  {
    title: 'The Guardian | The Long Read',
    scraping_content_selector: nil,
    url: 'https://www.theguardian.com/news/series/the-long-read/rss',
    use_scraper: false,
    category: Category.find_by(slug: 'long_form')
  },
  {
    title: 'BBC | The Reporters',
    scraping_content_selector: nil,
    url: 'http://feeds.bbci.co.uk/news/the_reporters/rss.xml',
    use_scraper: false,
    category: Category.find_by(slug: 'long_form')
  },
  {
    title: 'Long Form | All',
    scraping_content_selector: 'p',
    url: 'https://longform.org/feed.rss',
    use_scraper: true,
    category: Category.find_by(slug: 'long_form')
  }
]

feeds.each do |feed|
  channel = Channel.find_or_initialize_by(title: feed[:title])
  channel.update(feed)
end
