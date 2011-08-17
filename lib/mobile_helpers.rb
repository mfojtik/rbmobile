# This is a jquery.mobile[1] HAML helper to provide an easiest way
# to generate mobile application UI
#
# This helper could be used in Sinatra but also in Rails if properly
# included.
#
# Author::    Michal Fojtik (mi@mifo.sk)
# License::   GNU General Public License, version 2 (GPL-2.0)
# Copyright:: Michal Fojtik
#
# [1] http://jquerymobile.com


module RBMobile

  # Assume jquery.mobile installed in public/jquery.mobile-1.0b2/
  # NOTE: I tested this helper set with version 1.0b2 but you can of course
  #       use any latest/older version at your own risk.
  #       Please don't fill any tickets regarding to the jquery.mobile when
  #       you're using other version than 1.0b2. Only tickets that will be not
  #       deleted will be those with attached patch :-)
  #
  JQUERY_MOBILE_VERSION = 'jquery.mobile-1.0b2'

  # Assume jquery library installed in public/jquery-1.6.2.min.js
  # I don't think that jquery.mobile rely on exact JQuery version.
  JQUERY_VERSION = 'jquery-1.6.2'

  # Default configuration
  @configuration = {
    :ajax => true,
    :mobile_css_path => "/#{JQUERY_MOBILE_VERSION}/#{JQUERY_MOBILE_VERSION}.min.css",
    :mobile_js_path => "/#{JQUERY_MOBILE_VERSION}/#{JQUERY_MOBILE_VERSION}.min.js",
    :jquery_path => "/#{JQUERY_VERSION}.min.js"
  }

  # You can disable or enable configuration properties
  # using:
  #
  #   RBMobile::config do
  #     enable :property
  #     disable :property
  #   end
  #
  def self.config(&block)
    RBMobile::class_eval(&block) if block_given?
    @configuration
  end

  # This method enable given boolean property
  def self.enable(bool)
    @configuration[bool] = true
  end

  # This method disable given boolean property
  def self.disable(bool)
    @configuration[bool] = false
  end

  # Set URI path to jquery.mobile CSS file
  #
  # Default: "/#{JQUERY_MOBILE_VERSION}/#{JQUERY_MOBILE_VERSION}.min.css"
  #
  def self.jquery_mobile_css_path(path)
    @configuration[:mobile_css_path] = path
  end

  # Set URI path to jquery.mobile javascript file
  #
  # Default: "/#{JQUERY_MOBILE_VERSION}/#{JQUERY_MOBILE_VERSION}.min.js"
  #
  def self.jquery_mobile_js_path(path)
    @configuration[:mobile_js_path] = path
  end

  # Set URI path to jquery library
  #
  # Default: "/#{JQUERY_VERSION}.min.js"
  #
  def self.jquery_path(path)
    @configuration[:jquery_path] = path
  end

  # This module should be included as a view helper
  # In Sinatra you need to do following:
  #
  #   require 'mobile_helpers'
  #   helpers RBMobile::Helpers
  #
  # In Rails you should be able to include this module
  # inside your ApplicationHelper as:
  #
  #   require 'mobile_helpers'
  #   include RBMobile::Helpers
  #
  module Helpers

    # Include all necessary javascript and css libraries for jQuery mobile
    # You can exclude jQuery itself (in case your project is already including
    # this library somewhere else by:
    #
    #   = mobile_include(:no_jquery => true)
    #
    # This method should be placed right after %head tag.
    #
    # Additional options:
    #
    # [:scale]  Set initial scale of display (Default: 1)
    # [:no_jquery]  Disable inclusion of JQuery library
    #
    def mobile_include(opts={})
      capture_haml do
        haml_tag :meta, :name => 'viewport', :content => "width=device-width, initial-scale=#{opts[:scale] || '1'}"
        haml_tag :script, :type => 'text/javascript', :src => RBMobile::config[:jquery_path] unless opts[:no_jquery]
        haml_tag :link, :rel => 'stylesheet', :href => RBMobile::config[:mobile_css_path]
        haml_tag :script, :type => 'text/javascript', :src => RBMobile::config[:mobile_js_path]
      end
    end

    # The jQuery Mobile "page" structure is optimized to support either single
    # pages, or local internal linked "pages" within a page.
    #
    # The goal of this model is to allow developers to create websites using
    # best practices — where ordinary links will "just work" without any special
    # configuration — while creating a rich, native-like experience that can't
    # be achieved with standard HTTP requests
    #
    # This helper will generate:
    #
    #   <div data-role="page">
    #   </div>
    #
    # Additional properties that could be set:
    #
    # [:title] Set 'data-title' attribute
    # [:theme] Change mobile theme ('a'..'f')
    #
    # Example usage:
    #
    #   - page :theme => 'c' do
    #     - header do
    #       %h1 Header
    #
    def page(opts={}, &block)
      opts.merge!(:'data-title' => opts.delete(:title)) if opts[:title]
      role :page, opts, &block
    end

    # The header is a toolbar at the top of the page that usually contains the
    # page title text and optional buttons positioned to the the left and/or
    # right of the title for navigation or actions.
    # The title text is normally an H1 heading element but it's possible to use any
    # heading level (H1-H6) to allow for semantic flexibility. For example, a page
    # containing multiple mobile 'pages' may use a H1 element on the home 'page' and a
    # H2 element on the secondary pages. All heading levels are styled identically by
    # default to maintain visual consistency.
    #
    # This helper will generate:
    #
    #   <div data-role="header">
    #   </div>
    #
    # Additional properties that could be set:
    #
    # [:theme] Change mobile theme ('a'..'f')
    #
    def header(opts={}, &block)
      opts.merge!(:'data-position' => 'inline')
      role :header, opts, &block
    end

    # The content block is the main container for your content.
    #
    # This helper will generate:
    #
    #   <div data-role="content">
    #   </div>
    #
    # Additional properties that could be set:
    #
    # [:theme] Change mobile theme ('a'..'f')

    def content(opts={}, &block)
      role :content, opts, &block
    end

    # Any page can be presented as a modal dialog by adding the
    # data-rel="dialog" attribute to the page anchor link. When the "dialog"
    # attribute is applied, the framework adds styles to add rounded corners,
    # margins around the page and a dark background to make the "dialog" appear
    # to be suspended above the page.
    #
    #   <a href="foo.html" data-rel="dialog">Open dialog</a>
    #
    # This helper will generate a block that may contain a dialog:
    #
    #   <div data-role="dialog">
    #   </div>
    #
    # Additional properties that could be set:
    #
    # [:theme] Change mobile theme ('a'..'f')

    def dialog(opts={}, &block)
      role :dialog, opts, &block
    end

    # jQuery Mobile has a very basic navbar widget that is useful for providing
    # up to 5 buttons with optional icons in a bar , typically within a header
    # or footer.

    # A navbar is coded as an unordered list of links wrapped in a container
    # element that has the data-role="navbar" attribute. To set one of links to
    # the active (selected) state, add class="ui-btn-active" to the anchor. In
    # this example, we have a two-button navbar in the footer with the "One"
    # item set to active
    #
    # This helper will generate:
    #
    #   <div data-role="navbar">
		#     <ul>
    #     </ul>
    #   </div>
    #
    # Additional properties that could be set:
    #
    # [:theme] Change mobile theme ('a'..'f')

    def navbar(opts={}, &block)
      role :navbar, opts do
        haml_tag :ul do
          block.call if block_given?
        end
      end
    end

    # This helper will generate a link inside 'navbar' block:
    #
    #   - navbar do
    #     = navigate_to 'a.html', 'One'
    #     = navigate_to 'b.html', 'Two'
    #
    # Will produce:
    #
    #   <div data-role="navbar">
		#     <ul>
		# 	    <li><a href="a.html" class="ui-btn-active">One</a></li>
		# 	    <li><a href="b.html">Two</a></li>
		#     </ul>
	  #   </div>
    #
    # Additional properties that could be set:
    #
    # [:theme]   Change mobile theme ('a'..'f')
    # [:icon]    Icon to use, eg. 'delete' (refer to jquery mobile icon names)
    # [:active]  This will make current navigation item active
    #
    def navigate_to(url, label, opts={})
      options = {
        :href => url
      }.merge(opts)
      options.merge!(:class => 'ui-btn-active') if options.delete(:active)
      options.merge!(:'data-icon' => options.delete(:icon)) if options[:icon]
      capture_haml do
        haml_tag :li do
          haml_tag :a, options do
            haml_concat label
          end
        end
      end
    end

    # The footer bar has the same basic structure as the header except it uses the data-role attribute value of footer.
    #
    #   - footer do
    #     %h4 Footer content
    #
    # Will generate:
    #
    #   <div  data-role="footer">
	  #     <h4>Footer content</h4>
    #   </div>
    #
    # Additional properties that could be set:
    #
    # [:theme]   Change mobile theme ('a'..'f')
    # [:uibar]   Include padding on the bar
    # [:fixed]   Fixed toolbars will re-appear after you scroll

    def footer(opts={}, &block)
      opts.merge!(:class => "ui-bar") if opts.delete(:uibar)
      opts.merge!(:'data-position' => "fixed") if opts.delete(:fixed)
      role :footer, opts, &block
    end

    # Occasionally, you may want to visually group a set of buttons together to
    # form a single block that looks contained like a navigation component. To
    # get this effect, wrap a set of buttons in a container with the
    # data-role="controlgroup" attribute — the framework will create a vertical
    # button group, remove all margins and drop shadows between the buttons, and
    # only round the first and last buttons of the set to create the effect that
    # they are grouped together.
    #
    # This helper will generate:
    #
    #   - buttongroup :horizontal do
    #     = button :load, 'load.html', 'Load'
    #     = button :save, 'save.html', 'Save'
    #
    # Will produce:
    #
    #   <div data-role="controlgroup">
    #     <a href="load.html" data-role="button">Load</a>
    #     <a href="save.html" data-role="button">Save</a>
    #   </div>
    #
    # Additional properties that could be set:
    #
    # [kind]   The kind of group. Could be horizontal or vertical. Default: horizontal
    #
    def buttongroup(kind=:horizontal, &block)
      haml_tag :div, :'data-role' => "controlgroup", :'data-type' => "horizontal" do
        block.call if block_given?
      end
    end

    # Buttons that are used for navigation should be coded as anchor links, and
    # those that submit forms as button elements — each will be styled
    # identically by the framework.
    #
    # Example usage:
    #
    #   = button :save, 'save.html', 'Save', :theme => 'b'
    #   = button :save, 'save.html', 'Save', :ajax => true
    #
    # [kind]  Define icon used for button
    # [url]   Where to move after click
    # [label] Text displayed in button
    # [:theme] Change mobile theme ('a'..'f')
    # [:ajax]  Overide default AJAX setting

    def button(kind, url, label, opts={})
      options = {
        :'data-icon' => kind,
        :'data-role' => :button,
        :href => url
      }.merge(opts)
      options.merge!(:'data-ajax' => 'false') if not RBMobile::config[:ajax] and not options.delete(:ajax)
      options.merge!(:'data-theme' => options.delete(:theme)) if options[:theme]
      capture_haml do
        haml_tag :a, options do
          haml_concat label
        end
      end
    end

    # By default, all buttons in the body content are styled as block-level
    # element so they fill the width of the screen However, if you want a more
    # compact button that is only as wide as the text and icons inside, add the
    # data-inline="true" attribute to the button
    #
    # Example usage:
    #
    #   %p
    #     Click %{inline_button(:save, '/save', 'Save')} to submit changes
    #
    def inline_button(kind, url, label, opts={})
      opts.merge!(:'data-inline' => 'true')
      button(kind, url, label, opts)
    end

    # Using multiple column layouts isn't generally recommended on a mobile
    # device because of the narrow screen width, but there are times where you
    # may need to place small elements side-by-side (like buttons or navigation
    # tabs, for example).  The jQuery Mobile framework provides a simple way to
    # build CSS-based columns through a block style class convention called
    # ui-grid.  There are two preset configurations layouts — two-column (using
    # the class of ui-grid-a), and three-column (using the class of ui-grid-b) —
    # that can be used in any situation that requires columns. Grids are 100%
    # width, completely invisible (no borders or backgrounds) and don't have
    # padding or margins, so they shouldn't interfere with the styles of
    # elements placed inside them.
    #
    # Usage:
    #
    #   - grid do
    #     - column do
    #       Left content
    #     - column do
    #       Right content
    #
    # [columns] How many columns will be used (Default: 2)
    #
    def grid(columns=2, &block)
      @columns = ['ui-block-a', 'ui-block-b', 'ui-block-c'].reverse
      haml_tag :div, :class => (columns==2) ? 'ui-grid-a' : 'ui-grid-b' do
        block.call if block_given?
      end
    end

    # A single grid column
    #
    # Usage: see 'grid'
    #
    def column(&block)
      haml_tag :div, :class => @columns.pop do
        block.call if block_given?
      end
    end

    # To create a collapsible blocks of content, create a container and add the
    # data-role="collapsible" attribute.
    #
    # Usage:
    #
    #   - collapse "This content is collapsible" do
    #     %p Some content here!
    #
    #   <div data-role="collapsible">
	  #     <h3>I'm a header</h3>
	  #     <p>I'm the collapsible content. By default I'm open and displayed on the page, but you can click the header to hide me.</p>
	  #   </div>
    #
    # [title]      Give title to collapsable block
    # [:collapsed] Determine whenever this block is collapsed or not
    #
    def collapse(title, opts={}, &block)
      opts[:'data-collapsed'] = 'true' if opts.delete(:collapsed) or @collapsed
      role :collapsible, opts do
        haml_tag :h3 do
          haml_concat title
        end
        block.call
      end
    end

    # Collapsible sets start with the exact same markup as individual
    # collapsibles. By adding a parent wrapper with a
    # data-role="collapsible-set" attribute around a number of collapsibles, the
    # framework will style these to looks like a visually grouped widget and
    # make it behave like an accordion so only one section can be open at a
    # time.
    #
    # Example:
    #
    #   - collapse_set do
    #     - collapse 'This is collapsible' do
    #       Hello world!
    #     - collapse 'This is collapsible' do
    #       Hello world!
    #
    # Attributes:
    #
    # [:theme]  Change default theme
    #
    def collapse_set(opts={}, &block)
      @collapsed = true
      role :'collapsible-set', opts do
        block.call if block_given?
      end
    end

    # A list view is coded as a simple unordered list containing linked list
    # items with a data-role="listview" attribute. jQuery Mobile will apply all
    # the necessary styles to transform the list into a mobile-friendly list
    # view with right arrow indicator that fills the full width of the browser
    # window. When you tap on the list item, the framework will trigger a click
    # on the first link inside the list item, issue an AJAX request for the URL
    # in the link, create the new page in the DOM, then kick off a page
    # transition.
    #
    # Example:
    #   - list :theme => 'a', :filter => true do
    #      = divider "This is divider"
    #     - item do
    #       Hello World!
    #       = counter('3')
    #
    # [:filter] Determine if search filter will show up or not
    # [:ordered] Create ordered list instead of unordered (Use 'ordered_list' method for this)
    #
    def list(opts={}, &block)
      opts[:element] = opts.delete(:ordered) ? :ol : :ul
      opts[:'data-inset'] = 'true'
      opts[:'data-split-theme'] = opts.delete(:'split-theme') if opts[:'split-theme']
      opts[:'data-filter'] = opts.delete(:'filter') ? 'true' : 'false'
      role :'listview', opts do
        block.call if block_given?
      end
    end

    # Same as 'list' but instead of creating a unorder list will create an
    # ordered list
    #
    # Options:
    #
    # See 'list' method
    #
    def ordered_list(opts={}, &block)
      list(opts.merge(:ordered => true), &block)
    end

    # A single list item (li).
    #
    # Example: See 'list'
    #
    # Options:
    #
    # [:icon] Define the right icon in list
    # [:theme] Change default theme for single list item
    # [:item_icon_url] Allow to display custom (64x64) icon on the left side
    #
    def item(opts={}, &block)
      opts[:'data-icon'] = opts.delete(:icon) if opts[:icon]
      opts[:'data-theme'] = opts.delete(:theme) if opts[:theme]
      haml_tag :li, opts do
        block.call if block_given?
        haml_tag(:img, :src => opts[:item_icon_url], :class => 'ui-li-icon') if opts[:item_icon_url]
      end
    end

    # Same as list item ('item') but this will create a 'link' item.
    #
    # Example:
    #
    #   - list do
    #     - link 'a.html', :icon => 'alert' do
    #       This item will send you to a.html
    #
    # Options:
    #
    # See 'item' method
    #
    def link(url, opts={}, &block)
      original_block = block
      new_block = Proc::new do
        haml_tag :a, :href => url do
          original_block.call
        end
      end
      item(opts, &new_block)
    end

    # This will allow you to create a 'nested' list item.
    # Instead of showing just one single line in list item this will show a
    # header and text on bottom.
    #
    # Example:
    #
    #   - list do
    #     - nested_item 'This is item header', :theme => 'b' do
    #       This is item content
    #
    # Options:
    #
    # See 'item' method
    #
    def nested_item(title, opts={}, &block)
      original_block = block
      new_block = Proc::new do
        haml_tag :h3 do
          haml_concat title
        end
        original_block.call
      end
      item(opts, &new_block)
    end

    # This will add a small counter on the right side of list item.
    #
    # Example:
    #
    #   - list do
    #     - item do
    #       Active connections
    #       = counter '3'
    #
    def counter(value)
      capture_haml do
        haml_tag :span, :class => 'ui-li-count' do
          haml_concat value
        end
      end
    end

    # This will allow you to add an thumbnail on right side of list item.
    #
    # Example:
    #
    #   - list do
    #     - item do
    #       = thumb '/images/computer.png'
    #       Computer
    #
    def thumb(image_url)
      capture_haml do
        haml_tag :image, :class => 'ui-li-thumb', :src => image_url
      end
    end

    # This will create a list divider. It could be also used to create a contact
    # list alphabetically sorted.
    #
    #   - list do
    #     = divider "A"
    #     - item do
    #       Andreas Muller
    #
    # Options:
    #
    # [:theme]  Change default theme for divider (broken in jquery.mobile 1.0b2)
    #
    def divider(title, opts={})
      opts[:element] = :li
      capture_haml do
        role :'list-divider', opts do
          haml_concat title
        end
      end
    end

    # Wrapper for all HTML forms
    #
    # Example:
    #
    #   - form '/save', :post do
    #     = input :name, :text, 'Name'
    #     = textarea :text
    #     = search_input :city, 'City'
    #     = toogle :switch, 'Switch'
    #
    # Options:
    #
    # [url]     URL that handle the form data processing on the server
    # [method]  HTTP method to use (Default: POST)
    # [:ajax]   Overide default AJAX setting for this form
    #
    def form(url, method=:post, opts={}, &block)
      opts.merge!(
        :method => method,
        :url => url
      )
      opts.merge!(:'data-ajax' => 'false') if not RBMobile::config[:ajax] and not opts.delete(:ajax)
      haml_tag :form, opts do
        block.call if block_given?
      end
    end

    # Text inputs and textareas are coded with standard HTML elements, then
    # enhanced by jQuery Mobile to make them more attractive and useable on a
    # mobile.
    #
    # Example:
    #
    #   - form '/save' do
    #     = input :name, :text, 'Name'
    #     = input :surname, :text, 'Name', :required => true
    #
    # Options:
    #
    # [name]  Element name
    # [kind]  Element type (:text, :radio, :checkbox, ...)
    # [label] Element label (if nil, it will use 'name' as label)
    # [:value]  Default value for this input box
    # [:placeholder]  As soon as you click on (or tab to) the input field, the placeholder text disappears (HTML5)
    # [:required] Mark this input as required (HTML5)
    # [:patter] Validate value using regular expression (HTML5)
    # [:min]  Minimal value
    # [:max]  Maximum value
    # [:maxlength]  Maximum string length
    # [:checked] Mark this input as 'checked' (used in :checkbox os :radio 'kind')
    # [:no_complete] Disable autocompletetion
    #
    def input(name, kind, label=nil, opts={})
      capture_haml do
        form_field do
          haml_tag :label, :for => name do
            haml_concat label || name.to_s.capitalize
          end
          haml_tag :input, { :name => name, :id => name, :type => kind, :value => opts.delete(:value),
                             :placeholder => opts.delete(:placeholder), :required => opts.delete(:required) ? 'required' : nil,
                             :pattern => opts.delete(:pattern), :min => opts.delete(:min), :max => opts.delete(:max),
                             :maxlength => opts.delete(:maxlength) || opts.delete(:size), :checked => opts.delete(:checked) ? 'checked' : nil,
                             :autocomplete => opts.delete(:no_complete) ? 'off' : nil }.merge(opts)

        end
      end
    end

    # Search inputs are a new HTML type that is styled with pill-shaped corners
    # and adds a "x" icon to clear the field once you start typing.
    #
    # Example:
    #
    #   - form 'save' do
    #     = search_input :city, 'City'
    #
    # Options:
    #
    # [name]  Element name
    #
    # For more options see 'input' method.
    #
    def search_input(name, label=nil, opts={})
      input(name, :search, label, {
        :'data-type' => :search,
      }.merge(opts))
    end

    # To add a slider widget to your page, start with an input with a new HTML5
    # type="range" attribute. Specify the value (current value), min and max
    # attribute values to configure the slider.
    #
    # Example:
    #
    #   - form '/save' do
    #     = slider :cash, 0, 100, 'How much?'
    #
    # Options:
    #
    # [name] Element name
    # [min]  Starting value
    # [max]  Maximum value
    # [label] Element label
    # [:value]  Current value
    #
    # For other options see 'input' method
    #
    def slider(name, min, max, label=nil, opts={})
      input(name, :range, label, {
        :min => min,
        :max => max
      }.merge(opts))
    end

    # A binary "flip" switch is a common UI element on mobile devices that is
    # used for any binary on/off or true/false type of data input. You can
    # either drag the flip handle like a slider or tap on each half of the
    # switch.
    #
    # Example:
    #
    #   - form '/save' do
    #     = toogle :question, 'Be or not to be?'
    #
    # Options:
    #
    # [:first]  Replace default 'on' with custom text
    # [:second] Replace default 'off' with custom text
    #
    def toogle(name, label=nil, opts={})
      capture_haml do
        form_field do
          haml_tag :label, :for => name do
            haml_concat label || name.to_s.capitalize
          end
          haml_tag :select, :id => name, :'data-role' => 'slider' do
            haml_tag :option, :value => opts[:first] || 'on' do
              haml_concat opts[:first] ? opts[:first].to_s.capitalize : 'On'
            end
            haml_tag :option, :value => opts[:second] || 'off' do
              haml_concat opts[:second] ? opts[:second].to_s.capitalize : 'Off'
            end
          end
        end
      end
    end

    # The select menus are driven off native select elements, but the native
    # selects are hidden from view and replaced with a custom-styled select
    # button that matches the look and feel of the jQuery Mobile framework. The
    # replacement selects are ARIA-enabled and are keyboard accessible on the
    # desktop as well.
    #
    # Example:
    #
    #   - form '/save' do
    #     = select :pet, 'Select pet', ['Choose Pet', ['dog', 'Dog'], ['cat', 'Cat'], ['hamster', 'Hamster']]
    #
    # [name]  Element name
    # [label] Element label
    # [options] Array with select options. This array should contain two
    #           dimensional array with 'value' and 'name'. If array item is a string
    #           instead of array it's used as select placeholder
    # [:native] Enable native elements (don't use jquery.mobile UI)
    # [:theme]  Change theme for this select
    #
    def select(name, label=nil, options=[], opts={})
      opts = {
        :'data-native-menu' => opts.delete(:native) ? 'true' : 'false',
        :'data-theme' => opts.delete(:theme)
      }.merge(opts)
      capture_haml do
        form_field do
          haml_tag :label, :for => name do
            haml_concat label || name.to_s.capitalize
          end
          haml_tag :select, { :id => name }.merge(opts) do
            options.each do |option|
              option = [option] unless option.kind_of? Array
              # One-item array will create a placeholder
              haml_tag :option, :value => option.size==2 ? option.first : nil, :'data-placeholder' => option.size==1 ? 'true' : nil do
                haml_concat option.last
              end
            end
          end
        end
      end
    end

    # Radio buttons are used to provide a list of options where only a single
    # items can be selected. Traditional desktop radio buttons are not optimized
    # for touch input so in jQuery Mobile, we style the label for the radio
    # buttons so they are larger and look clickable. A custom set of icons are
    # added to the label to provide additional visual feedback.
    #
    # Example:
    #
    #   - form '/save' do
    #     = radio :pet, 'Choose pet vertical', ['cat', :dog, 'hamster', 'honey badger']
    #     = radio :pet, 'Choose pet', ['cat', :dog, 'hamster', 'honey badger'], :type => :horizontal
    #
    # Options:
    #
    # [name]  Element name
    # [label] Element label
    # [options] List of possible options. Use 'Symbol' instead of 'String' if you want to make some value 'checked'
    # [:type] You can have 'horizontal' or 'vertical' radio group (Default: vertical)
    #
    def radio(name, label=nil, options=[], opts={})
      capture_haml do
        form_field do
          haml_tag :fieldset, :'data-role' => :controlgroup, :'data-type' => opts[:type] || 'vertical' do
            haml_tag :legend do
              haml_concat label || name.to_s.capitalize
            end
            options.each_with_index do |option, index|
              haml_tag :input, :name => name, :id => "#{name}-choice-#{index}", :type => :radio,
                               :value => option, :checked => option.kind_of?(Symbol) ? 'checked' : nil
              haml_tag :label, :for => "#{name}-choice-#{index}" do
                haml_concat option
              end
            end
          end
        end
      end
    end

    # Checkboxes are used to provide a list of options where more than one can
    # be selected. Traditional desktop checkboxes are not optimized for touch
    # input so in jQuery Mobile, we style the label for the checkboxes so they
    # are larger and look clickable. A custom set of icons are added to the
    # label to provide additional visual feedback.

    # Both the radio and checkbox controls below use standard input/label
    # markup, but are styled to be more touch-friendly. The styled control you
    # see is actually the label element, which sits over the real input, so if
    # images fail to load, you'll still have a functional control. In most
    # browsers, clicking the label automatically triggers a click on the input,
    # but we've had to trigger the update manually for a few mobile browsers
    # that don't do this natively. On the desktop, these controls are keyboard
    # and screen-reader accessible.
    #
    # Examples:
    #
    #   - form do
    #     = checkbox :pet, 'Choose multiple pets', ['cat', :dog, 'hamster', 'honey badger']
    #     = checkbox :pet, 'Choose multiple pets horizontal', ['cat', :dog, 'hamster', 'honey badger'], :type => :horizontal
    #
    # Options:
    #
    # See 'radio' method.
    #
    def checkbox(name, label=nil, options=[], opts={})
      capture_haml do
        form_field do
          haml_tag :fieldset, :'data-role' => :controlgroup, :'data-type' => opts[:type] || 'vertical' do
            haml_tag :legend do
              haml_concat label || name.to_s.capitalize
            end
            options.each_with_index do |option, index|
              haml_tag :input, :name => "name[#{index}]", :id => "#{name}-choice-#{index}", :type => :checkbox,
                               :value => option, :checked => option.kind_of?(Symbol) ? 'checked' : nil
              haml_tag :label, :for => "#{name}-choice-#{index}" do
                haml_concat option
              end
            end
          end
        end
      end
    end

    # For multi-line text inputs, use a textarea element. The framework will
    # auto-grow the height of the textarea to avoid the need for an internal
    # scrollbar which is very hard to use on a mobile device.
    #
    # Examples:
    #
    #   - form do
    #     = textarea :text
    #
    # Options:
    #
    # [name]  Element name
    # [label] Element label
    # [:cols] Number of columns
    # [:rows] Number of rows
    # [:placeholder] See 'input'
    # [:required] Make textarea required (HTML5)
    # [:content]  Insert some content into textarea
    # [:maxlength]  Maximum text length (HTML5)
    #
    def textarea(name, label=nil, opts={})
      capture_haml do
        form_field do
          haml_tag :label, :for => name do
            haml_concat label || name.to_s.capitalize
          end
          haml_tag :'textarea', :'<', :name => name, :id => name, :cols => opts[:cols], :rows => opts[:rows],
            :placeholder => opts[:placeholder], :required => opts[:required] ? 'required' : nil,
            :maxlength => opts[:maxlength] do
            haml_concat opts[:content] if opts[:content]
          end
        end
      end
    end

    # Basic wrapper for all form fields
    #
    # Options:
    #
    # [:theme]  Change default theme
    #
    def form_field(opts={}, &block)
      role :'fieldcontain', opts, &block
    end

    # Form submitter
    #
    # Example:
    #
    #   - form do
    #     = submit 'Submit this form'
    #
    # Options:
    #
    # [label]   Text displayed in button (Default: 'Submit')
    # [:theme]  Change the default theme for button
    #
    def submit(label=nil, opts={})
      opts = {
        :'data-theme' => opts.delete(:theme)
      }.merge(opts)
      capture_haml do
        form_field do
          haml_tag :button, { :type => :submit }.merge(opts), :value => label do
            haml_concat label || 'Submit'
          end
        end
      end
    end

    private

    def role(name, opts={}, &block)
      options = {
        :'data-role' => name
      }
      options.merge!(:'data-theme' => opts.delete(:theme)) if opts[:theme]
      options.merge!(opts)
      element = options.delete(:element) || :div
      haml_tag element, options do
        block.call if block_given?
      end
    end

  end
end
