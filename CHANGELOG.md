# Change log

## [v0.2.0] - 2024-11-03

### Added
* Add the ability to configure the environment variables, hyperlink detection,
  output stream and plain URL template to the initialize method
* Add the ability to configure the hyperlink detection with the environment
  variable
* Add the ability to create hyperlinks from the URL only to the link_to method
* Add an attrs option to the link_to method to allow configuring URL attributes
* Add hyperlinks support detection in Alacritty, Contour, DomTerm, foot, Hyper,
  JediTerm, kitty, Konsole, mintty, Rio, Tabby, Terminology, VSCode, WezTerm
  and Windows Terminal

### Changed
* Change the BEL and OSC control characters from Unicode to escape code
* Change the OSC constant to OSC8 to include the hyperlink control number
* Change the TTY::Link module to a class
* Change the TTY::Link class to remove the ESC constant
* Change the TTY::Link class constants to be private
* Change the TTY::Link class to check the iTerm program version presence
* Change the support_link? method to rename to link?

## [v0.1.1] - 2020-01-25

### Changed
* Change gemspec to add metadata and remove test artefacts

## [v0.1.0] - 2019-08-10

* Initial implementation and release

[v0.2.0]: https://github.com/piotrmurach/tty-link/compare/v0.1.1...v0.2.0
[v0.1.1]: https://github.com/piotrmurach/tty-link/compare/v0.1.0...v0.1.1
[v0.1.0]: https://github.com/piotrmurach/tty-link/compare/v0.1.0
