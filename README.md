# Coder

A Ruby library to deal with encodings, no matter if you're on 1.8 or 1.9, JRuby
or Rubinius, if you have a working iconv or not, it chooses the best way for you
to handle String encodings.

## Usage

At the moment, Coder only cleans strings for you. I plan to add string
conversion and encoding detection later.

### Cleaning Strings

``` ruby
Coder.clean(some_string)
```

You can also specify the encoding:


``` ruby
Coder.clean(some_string, 'UTF-8')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
