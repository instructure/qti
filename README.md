# QTI Gem

The Qti gem supports QTI 1.2 and 2.1. It currently supports the following interaction types:

  - True/False
  - Multiple Choice
  - Multiple Answer


## Installation

```sh
$ cd your_project
$ bundle install qti
```


## Usage

```rb
require 'qti'
@gem = Qti::Importer.new(path_of_quiz)
```

You can use the gem to access the manifest, the assessments, and the assessment
items and use it in your own code!

### Available methods

   - `import_manifest`

Returns the version appropriate href from the manifest.xml

   - `test_object`

Returns the version appropriate Assessment/AssessmentTest model

  - `create_assessment_item(assessment_item_ref)`

Returns the version appropriate AssessmentItem model

#### Available Methods on the Assessment (QTI 1.2)
  - `title`
  - `assessment_items`

#### Available Methods on the AssessmentTest (QTI 2.1)
  - `title`
  - `assessment_item_reference_hrefs` (the hrefs of the xml files in the assessment.xml)
  - `test_parts`
  - `assessment_sections`

#### Available Methods on the AssessmentItem
  - `identifier`
  - `title`
  - `points_possible`
  - `rcardinality` (QTI 1.2)
  - `interaction_model` (ie Choice Interaction)
  - `scoring_data_structs`


## Development

A simple docker environment has been provided for spinning up and testing this
gem with multiple versions of Ruby. This requires docker and docker-compose to
be installed. To run specs, run the following:

```bash
docker-compose build --pull
docker-compose run --rm app
```

This will install the gem in a docker image with all versions of Ruby installed,
and install all gem dependencies in the Ruby 2.5 set of gems. Then it will run
[wwtd](https://github.com/grosser/wwtd), which runs all specs across all
supported versions of Ruby and gem dependencies.

The first build will take a long time, however, docker images and gems are
cached, making additional runs significantly faster.

Individual spec runs can be started like so:

```bash
docker-compose run --rm app /bin/bash -l -c \
  "BUNDLE_GEMFILE=spec/gemfiles/rails-6.0.gemfile rvm-exec 2.5 rspec"
```

If you'd like to mount your git checkout within the docker container running
tests so changes are easier to test, use the override provided:

```bash
cp docker-compose.override.example.yml docker-compose.override.yml
```


## Contributing

Bug reports and pull requests are welcome on GitHub at:

- https://github.com/instructure/qti


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
