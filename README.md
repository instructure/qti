# Qti Importer

Qti gem is a Qti 1.2 and 2.x compliant importer. It currently handles the following interaction types:

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

Now you can use the gem to access the manifest, the assessments, and the assesment items and use it in your own code!

### Development

Want to contribute? Submit a pull request!

### To Do
  - More interaction types!
