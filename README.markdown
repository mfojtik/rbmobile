# Ruby jquery.mobile

A swiss knife for creating a hipster rich user-interfaces supposed to looks great on mobile devices.

### Description

This project should help you to create more readable HAML templates for your
mobile application using http://jquerymobile.com framework.

### Example

Save your fingers! and write this code:

    - page :theme => 'c' do
      - header do
        %h1 Page header
      - content do
        - list do
          = divider "Awesome list"
          - item do
            Awesome list item
      - footer do
        - navbar do
          - navigate_to 'a.html', 'Awesome', :icon => 'load'
          - navigate_to 'b.html', 'Yeah!', :icon => 'save'

Instead of this code:

    %div{ :'data-role' => 'page', :'data-theme' => 'c'}
      %div{ :'data-role' => 'header'}
        %h1 Page header
      %div{ :'data-role' => 'content'}
        %ul{ :'data-role' => 'list-view'}
          %li{ :'data-role' => 'listdivider'} Awesome list
          %li Awesome list item
      %div{ :'data-role' => 'footer' }
        %div{ :'data-role' => 'navbar'}
          %ul
            %li
              %a{ :href => 'a.html', :'data-icon' => :save } Awesome
              %a{ :href => 'a.html', :'data-icon' => :save } Awesome

And there is even more magic and autogenerator inside!

### Documentation


- RDoc: http://rdoc.info/projects/mfojtik/rbmobile
- JQuery.Mobile: http://jquerymobile.com

### Requirements

- You should include JQuery library in your project or place this library into
  'public' folder (it should be accessible in /jquery-xxx.min.js)

- You should unzip JQuery mobile inside your 'public' folder:

    $ wget http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.zip  \
      -O public/jquery.mobile-1.0b2.zip
    $ cd public && unzip jquery.mobile-1.0b2.zip
  
- JQuery.mobile folder should be accessible in /jquery.mobile-xxx/


### Installation

    gem install rbmobile
    
### Demo app

    $ git clone git://github.com/mifo/rbmobile.git
    $ gem install sinatra sinatra-respond_to
    $ cd rbmobile/example
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

- Finish with jquery.mobile forms
- Make public directory configurable

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

