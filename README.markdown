# Ruby JQuery Mobile HAML helper

A swiss knife for creating a hipster UI like from Apple

### Description

This project should help you to create more readable HAML templates for your
mobile applications using http://jquerymobile.com framework.


### Documentation

http://rdoc.info/projects/mfojtik/rbmobile

### Requirements

- You should include JQuery library in your project or place this library into
  'public' folder
- You should unzip JQuery mobile inside your 'public' folder:

    $ wget http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.zip -O public/jquery.mobile-1.0b2.zip
    $ cd public && unzip jquery.mobile-1.0b2.zip

### Installation

    gem install rbmobile
    
### Demo

    $ gem install sinatra sinatra-respond_to
    $ ruby app.rb
    $ open http://localhost:4567/ 

### Sinatra

    require 'mobile_helpers'
    helpers RBMobile::Helpers

### Rails(?)

app/helpers/application_helper.rb:

    require 'mobile_helpers'
    include RBMobile::Helpers

### TODO:

- Finish forms.

### LICENSE:

Copyright (c) 20011 Michal Fojtik

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

