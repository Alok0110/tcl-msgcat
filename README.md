# Tcl::Msgcat

Library for parsing, rendering and merging TCL msgcat (read i18n) files.

TCL msgcat files are yuk, and a legacy format.  Unfortunately some of us are stuck with systems that still use these files
for i18n in TCL applications.  Managing these files can be a bit annoying, especially when they are large and you have
many different people translating them.  What's more, TCL doesn't report line numbers in it's error messages!!!  So if you have
an error in your 7000 line msgcat file, good luck finding it!

This library aims to solve that problem by storing the translations in JSON and compiling them to the TCL msgcat format.  JSON
is easily lintable and most syntax checkers tell you which line any errors are on.  Plus it is a modern standard and supported
by lots of languages which are better than TCL so you can programmatically update changes between your root message file and
your translation files.  Which is another thing this library does.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tcl-msgcat'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tcl-msgcat

## Usage

You'll want to convert your existing files first.  You can do this with the following command:

    msgcat parse root.msg > root.json
    msgcat parse zh_tw.msg > zh_tw.json

And render it back to the msgcat file:

    msgcat render root.json > root.test.msg

OK, now say you have added a bunch of strings to your `root.json` for some new stuff in the application. You
will want to update all your other files with those strings, and send them off to your translators.  For this
there is the `merge` action with a few ways to use it:

    msgcat merge root.json fr.json de.json es.json # specify files individually
    msgcat merge root.json *.json                  # or glob them (root.json is automatically excluded)

Now you have got your files back from the translators, put them through a [linter](http://jsonlint.com/)
and found no errors.  You are ready to put those new translations back into your application. Use the `compile`
action to run the render command on all your json files:

    msgcat compile ui/msgs                 # only one arg needed if you don't segregate source/compiled
    msgcat compile ui/msgs/source ui/msgs  # otherwise specify the source and compile paths seperately

## Contributing

1. Fork it ( https://github.com/AutogrowSystems/tcl-msgcat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
