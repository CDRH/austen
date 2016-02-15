Austen
===========

## Run locally

If you have not used git before, install git and set up your SSH keys.  You will also need ruby, rails, and bundler installed.

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

The novel and chapter visualizations as well as the frequency page displaying characters / traits are generated with a ruby script.  These should only need to be regenerated should something about the TEI-XML change.  You will need to have saxon installed as a global command in order to run the first part of the script.  See [the data repository's instructions](https://github.com/CDRH/data#saxon) for how to set this up.  To run the script, move to the root of the repository:

```
ruby scripts/generate_austen_html.rb
```

You will be given choices about what you would like to generate.

```
Please select one:
    [a] only generate novel and chapter visualization
    [b] only generate word frequencies for all novels
    [c] everything, generate everything!
```

`[a]` : the full text and chapter text of the novels  (requires saxon, slow)

`[b]` : generates both the HTML required for browsing character word frequencies, and also the JSON snippets of the frequencies  (quick)

Make sure that if you have changed any of the novel TEI files that you commit those changes and any changes to the novel / chapter / frequency files back to git when you are done.
