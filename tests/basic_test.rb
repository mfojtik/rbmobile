require 'rubygems'
require 'haml'
require 'lib/mobile_helpers'
require 'minitest/autorun'
require 'nokogiri'

class TestRoles < MiniTest::Unit::TestCase

  extend Haml
  include Haml::Helpers
  include RBMobile::Helpers

  def setup
    init_haml_helpers
    RBMobile::config do
      disable :ajax
    end
  end

  def test_it_generates_basic_page_role
    output = capture_haml do
      page
    end
    retval = Nokogiri::HTML(output)
    assert_equal retval.css("div").size, 1
    assert_nil retval.css("div").first[:class]
    assert_equal retval.css("div").first[:'data-role'], 'page'
    assert_empty retval.css("div *")
  end

  def test_it_generates_themed_page_role
    output = capture_haml do
      page :theme => :c
    end
    retval = Nokogiri::HTML(output)
    assert_equal retval.css("div").first[:'data-theme'], 'c'
  end

  def test_it_generates_titled_page_role
    output = capture_haml do
      page :title => "Test1"
    end
    retval = Nokogiri::HTML(output)
    assert_equal retval.css("div").first[:'data-title'], 'Test1'
  end

  def test_it_generates_basic_header_role
    output = capture_haml do
      page do
        header do
        end
      end
    end
    retval = Nokogiri::HTML(output)
    assert_equal retval.css("div[@data-role=page] div").size, 1
    assert_equal retval.css("div[@data-role=page] div").first[:'data-role'], "header"
    assert_equal retval.css("div[@data-role=page] div").first[:'data-position'], "inline"
  end
  
  def test_it_generates_basic_navbar_role
    output = capture_haml do
      page do
        footer do
          navbar do
            haml_concat navigate_to "a.html", "Test"
          end
        end
      end
    end
    retval = Nokogiri::HTML(output)
    assert_equal retval.css("div[@data-role=page] > div").size, 1
    assert_equal retval.css("div[@data-role=page] div").first[:'data-role'], "footer"
    assert_equal retval.css("div[@data-role=page] div[@data-role=footer] div").first[:'data-role'], "navbar"
    assert_equal retval.css("div[@data-role=page] div[@data-role=footer] div").size, 1
    assert_equal retval.css("div[@data-role=page] div[@data-role=footer] div ul").size, 1
    assert_equal retval.css("div[@data-role=page] div[@data-role=footer] div ul li").size, 1
    assert_equal retval.css("div[@data-role=page] div[@data-role=footer] div ul li a").size, 1
    assert_equal retval.css("div[@data-role=page] div[@data-role=footer] div ul li a").first[:href], 'a.html'
    assert_equal retval.css("div[@data-role=page] div[@data-role=footer] div ul li a").first.text.strip, 'Test'
  end





end
