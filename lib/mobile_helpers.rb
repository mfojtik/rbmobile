module RBMobile

  JQUERY_MOBILE_VERSION = 'jquery.mobile-1.0b2'
  JQUERY_VERSION = 'jquery-1.6.2'

  @configuration = {
    :ajax => true
  }

  def self.config(&block)
    RBMobile::class_eval(&block) if block_given?
    @configuration
  end

  def self.enable(bool)
    @configuration[bool] = true
  end

  def self.disable(bool)
    @configuration[bool] = false
  end

  module Helpers

    def mobile_include
      capture_haml do
        haml_tag :meta, :name => 'viewport', :content => 'width=device-width, initial-scale=1'
        haml_tag :link, :rel => 'stylesheet', :href => "/#{JQUERY_MOBILE_VERSION}/#{JQUERY_MOBILE_VERSION}.min.css"
        haml_tag :script, :type => 'text/javascript', :src => "/#{JQUERY_VERSION}.min.js"
        haml_tag :script, :type => 'text/javascript', :src => "/#{JQUERY_MOBILE_VERSION}/#{JQUERY_MOBILE_VERSION}.min.js"
      end
    end

    def page(opts={}, &block)
      opts.merge!(:'data-title' => opts.delete(:title)) if opts[:title]
      role :page, opts, &block
    end

    def header(opts={}, &block)
      opts.merge!(:'data-position' => 'inline')
      role :header, opts, &block
    end

    def content(opts={}, &block)
      role :content, opts, &block
    end

    def dialog(opts={}, &block)
      role :dialog, opts, &block
    end

    def navbar(opts={}, &block)
      role :navbar, opts do
        haml_tag :ul do
          block.call if block_given?
        end
      end
    end

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

    def footer(opts={}, &block)
      opts.merge!(:class => "ui-bar")
      opts.merge!(:'data-position' => "fixed") if opts.delete(:fixed)
      role :footer, opts, &block
    end

    def buttongroup(kind=:horizontal, &block)
      capture_haml do
        haml_tag :div, :'data-role' => "controlgroup", :'data-type' => "horizontal" do
          block.call if block_given?
        end
      end
    end

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

    def inline_button(kind, url, label, opts={})
      opts.merge!(:'data-inline' => 'true')
      button(kind, url, label, opts)
    end

    def grid(columns=2, &block)
      @columns = ['ui-block-a', 'ui-block-b', 'ui-block-c'].reverse
      capture_haml do
        haml_tag :div, :class => (columns==2) ? 'ui-grid-a' : 'ui-grid-b' do
          block.call if block_given?
        end
      end
    end

    def column(&block)
      capture_haml do
        haml_tag :div, :class => @columns.pop do
          block.call if block_given?
        end
      end
    end

    def collapse(title, opts={}, &block)
      opts[:'data-collapsed'] = 'true' if opts.delete(:collapsed) or @collapsed
      role :collapsible, opts do
        haml_tag :h3 do
          haml_concat title
        end
        block.call
      end
    end

    def collapse_set(opts={}, &block)
      @collapsed = true
      role :'collapsible-set', opts do
        block.call if block_given?
      end
    end

    def list(opts={}, &block)
      opts[:element] = opts.delete(:ordered) ? :ol : :ul
      opts[:'data-inset'] = 'true'
      opts[:'data-split-theme'] = opts.delete(:'split-theme') if opts[:'split-theme']
      role :'listview', opts do
        block.call if block_given?
      end
    end

    def ordered_list(opts={}, &block)
      list(opts.merge(:ordered => true), &block)
    end

    def item(opts={}, &block)
      opts[:'data-icon'] = opts.delete(:icon) if opts[:icon]
      opts[:'data-theme'] = opts.delete(:theme) if opts[:theme]
      capture_haml do
        haml_tag :li, opts do
          block.call if block_given?
        end
      end
    end

    def link(url, opts={}, &block)
      original_block = block
      new_block = Proc::new do
        haml_tag :a, :href => url do
          original_block.call
        end
      end
      item(opts, &new_block)
    end

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

    def counter(value)
      capture_haml do
        haml_tag :span, :class => 'ui-li-count' do
          haml_concat value
        end
      end
    end

    def divider(title, opts={})
      opts[:element] = :li
      role :'list-divider', opts do
        haml_concat title
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
      #capture_haml do
        haml_tag element, options do
          block.call if block_given?
        end
      #end
    end

  end
end
