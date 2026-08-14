# Change log

## [v0.2.0] - 2024-11-03

### Added
* Add the ability to configure the environment variables with the env option,
  hyperlink support detection with the hyperlink option,
  output stream with the output option
  and plain URL template with the plain option to the initialize method
* Add the ability to configure the hyperlink support detection
  with the TTY_LINK_HYPERLINK environment variable
* Add the ability to create hyperlinks using only the URL to the link_to method
* Add the ability to configure the hyperlink attributes with the attrs option
  to the link_to method
* Add hyperlinks support detection for Alacritty, Contour, DomTerm, foot,
  Hyper, JediTerm, kitty, Konsole, mintty, Rio, Tabby, Terminology, VS Code,
  WezTerm and Windows Terminal

### Changed
* Change the link_to method to use escape sequences for control characters
* Change the TTY::Link module to a class
* Change the TTY::Link class constants to be private
* Change the TTY::Link class to check whether the iTerm version exists
* Change the TTY::Link class to rename the support_link? method to link?

## [v0.1.1] - 2020-01-25

### Changed
* Change the email address and the homepage URL in the gemspec

### Removed
* Remove the binary scripts, configuration files, Markdown templates
  and Rake tasks from the build files in the gemspec

## [v0.1.0] - 2019-08-10

### Added
* Add the initial implementation

[v0.2.0]: https://github.com/piotrmurach/tty-link/compare/v0.1.1...v0.2.0
[v0.1.1]: https://github.com/piotrmurach/tty-link/compare/v0.1.0...v0.1.1
[v0.1.0]: https://github.com/piotrmurach/tty-link/compare/v0.1.0
