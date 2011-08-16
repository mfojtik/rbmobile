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
  JQUERY_MOBILE_VERSION = 'jquery.mobile-1.0b2'

  # Assume jquery library installed in public/jquery-1.6.2.min.js
  JQUERY_VERSION = 'jquery-1.6.2'

  # Default configuration
  @configuration = {
    :ajax => true
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
    def mobile_include(opts={})
      capture_haml do
        haml_tag :meta, :name => 'viewport', :content => 'width=device-width, initial-scale=1'
        haml_tag :link, :rel => 'stylesheet', :href => "/#{JQUERY_MOBILE_VERSION}/#{JQUERY_MOBILE_VERSION}.min.css"
        unless opts[:no_jquery]
          haml_tag :script, :type => 'text/javascript', :src => "/#{JQUERY_VERSION}.min.js"
        end
        haml_tag :script, :type => 'text/javascript', :src => "/#{JQUERY_MOBILE_VERSION}/#{JQUERY_MOBILE_VERSION}.min.js"
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
    # [title] Set 'data-title' attribute
    # [theme] Change mobile theme ('a'..'f')
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
    # [theme] Change mobile theme ('a'..'f')
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
    # [theme] Change mobile theme ('a'..'f')

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
    # [theme] Change mobile theme ('a'..'f')

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
    # [theme] Change mobile theme ('a'..'f')

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
    # [theme]   Change mobile theme ('a'..'f')
    # [icon]    Icon to use, eg. 'delete' (refer to jquery mobile icon names)
    # [active]  This will make current navigation item active
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
    # [theme]   Change mobile theme ('a'..'f')
    # [uibar]   Include padding on the bar
    # [fixed]   Fixed toolbars will re-appear after you scroll

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
    # [theme] Change mobile theme ('a'..'f')
    # [ajax]  Overide default AJAX setting

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
    # [collapsed] Determine whenever this block is collapsed or not
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
    # [filter] Determine if search filter will show up or not
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
    def ordered_list(opts={}, &block)
      list(opts.merge(:ordered => true), &block)
    end

    # A single list item (li).
    #
    # Example: See 'list'
    #
    # Options:
    #
    # [icon] Define the right icon in list
    # [theme] Change default theme for single list item
    # [item_icon_url] Allow to display custom (64x64) icon on the left side
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
    def divider(title, opts={})
      opts[:element] = :li
      capture_haml do
        role :'list-divider', opts do
          haml_concat title
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
