![](logo.png)

AI enhanced news aggregation.


## Technical summary
POLYNews provides an integrated approach to reading news from a variety of
sources.

Articles are retrieved via public RSS and grouped by story using a TF-IDF BOW
model and the most important news of the day is inferred by how extensively a
story is covered across multiple sources.


## Requirements
- Postgres 12
- Ruby 2.6
- Node 14
- Yarn 1.22
- Heroku CLI


## Roadmap
- Track article popularity and integrate that into the headline/most important logic.
- Customized user recommendations using past viewing history to train the model.
- Expand categories and sources to provide more granular and in depth coverage.
- Switch to a magazine-like UI which emphasizes article importance


## Application setup
Prepare the application for local execution with:
```
> bin/setup
```

Among other things, this will:
- Setup the heroku remote
- Install Ruby and JS dependencies
- Create, migrate and seed the database
- Download and group the first batch of news articles
- Run the specs and lint the application


## Code Verification
POLYNews uses a variety of tools to maintain code correctness, consistency
and quality. Before merging new code the expectation is:
- All specs pass (rspec)
- 90% test coverage (simplecov)
- Adherence to the style guide (no rubocop offenses / specifically disable where necessary)
- Minimum 90% quality score on all code files (rubycritic)

To verify the application run:
```
> bin/verify
```


## Run the application
Run the following:
```
> bin/rails server
```

Application is available at `localhost:3000`.

The root and `/news` routes provide the public interface for the application.

Admin routes are accessible at `/channels`. In production, the admin routes are
protected with HTTP Basic Authorization. Set the `ADMIN_USERNAME` and
`ADMIN_PASSWORD` environment variables to specify admin credentials.

The admin routes are useful for troubleshooting, but generally changes should be
made via the db seeds.


## Configuring and updating the news sources
The `news:update` rake task is provided for refreshing the current news articles.

The `news:full_refresh` rake task will completly refresh the news by emptying 
the db, reseeding and then downloading articles from scratch. This is particularly
helpful when large scale changes are made to the channels.


## Production
POLYNews is available online at [polynews.co](polynews.co)
