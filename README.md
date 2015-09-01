Austen
===========

## Run locally

```
git clone git@github.com:CDRH/austen.git
cd austen
bundle install
```

Copy `config/database_demo.yml`, `config/secrets_demo.yml`, and `config_demo.yml` to new files like `config/database.yml`.  You will not need to change secrets or database, but you will need to fill out the correct solr core for `config/config.yml`.

```
rails s
```
