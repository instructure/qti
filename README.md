---
content_id: "121077930"
title: Qti
---
# Qti Gem

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

You can use the gem to access the manifest, the assessments, and the assessment items and use it in your own code!

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
  - ` interaction_model` (ie Choice Interaction)
  - `scoring_data_structs`

## Running Tests
You can run tests with code coverage using the following command:
  `docker-compose run --rm -e RAILS_ENV=test -e COVERAGE=1 testrunner bundle exec rspec spec`
  
## Development

Want to contribute? Submit a pull request!

## To Do
  - More interaction models!
