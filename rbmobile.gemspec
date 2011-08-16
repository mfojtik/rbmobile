require 'rake'

Gem::Specification.new do |s|
  s.author = 'Michal Fojtik'
  s.homepage = "http://github.com/mifo/rbmobile"
  s.email = 'mi@mifo.sk'
  s.name = 'rbmobile'

  s.description = <<-EOF
    A swiss knife to create a hipster UI using jquery.mobile framework.
    Provides set of HAML helpers to make your template more beautifull.
  EOF

  s.version = '0.0.1'
  s.date = Time.now
  s.summary = %q{jquery.mobile HAML helpers}
  s.files = FileList[
    'lib/mobile_helpers.rb',
    'README.markdown'
  ].to_a

  s.required_ruby_version = '>= 1.8.1'
  s.add_dependency('haml')
end
