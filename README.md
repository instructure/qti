# Qti Gem

The Qti gem supports QTI 1.2 and 2.1. It currently supports the following interaction types:

  - True/False
  - Multiple Choice
  - Multiple Answer

### Installation

```sh
$ cd your_project
$ bundle install qti
```

### Usage

`require 'qti'`
`@gem = Qti::Importer.new(path_of_quiz)`

Now you can use the gem to access the manifest, the assessments, and the assessment items and use it in your own code!

### Development

Want to contribute? Submit a pull request!

### To Do
  - More interaction models!
