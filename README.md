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

## Generate HTML

The novel and chapter visualizations as well as the frequency page displaying characters / traits are generated with a ruby script.  These should only need to be regenerated should something about the TEI-XML change.  To run, move to the root of the repository:

```
ruby scripts/generate_austen_html.rb
```
