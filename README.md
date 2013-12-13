# TML Code Converter

[![Build Status](https://travis-ci.org/mmcclimon/tml-code-converter.png?branch=master)](https://travis-ci.org/mmcclimon/tml-code-converter)
[![Coverage Status](https://coveralls.io/repos/mmcclimon/tml-code-converter/badge.png)](https://coveralls.io/r/mmcclimon/tml-code-converter)
[![Code Climate](https://codeclimate.com/github/mmcclimon/tml-code-converter.png)](https://codeclimate.com/github/mmcclimon/tml-code-converter)

This is an attempt to convert the codes for noteshapes used in the
[Thesaurus Musicarum Latinarum](http://chmtl.indiana.edu/tml) to
something more readable. For now, this means trying to convert to
[MEI](http://music-encoding.org).

Musical notation in the TML is represented by a complex encoding which is
described [here](http://www.chmtl.indiana.edu/tml/tofc1.html) and
[here](http://www.chmtl.indiana.edu/tml/tofc2.html). These symbols are nearly
impossible to read unless one is very familiar with them. This project
attempts to parse them into MEI, which can then (eventually) be used to
represent the examples graphically.

See the project in action at http://tml-code-converter.herokuapp.com/.

## Technical notes

Prerequisites:

Ruby 2.0, [Sinatra](http://sinatrarb.com) (for web app),
[Nokogiri](http://nokogiri.org) (for XML building/parsing).

Running locally:

Clone this repo, run `bundle install`, and then `shotgun config.ru`. This will
bring up a local server accessible at http://localhost:9393 where you can play
around.

## Contact

This is a project of the [Center for the History of Music Theory and
Literature](http://chmtl.indiana.edu/) at the [Jacobs School of
Music](http://music.indiana.edu), [Indiana University](http://indiana.edu).
Contact us at chmtl@indiana.edu with any questions or comments.
