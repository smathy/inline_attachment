# -*- encoding: utf-8 -*-

module_name = "inline_attachment"

Gem::Specification.new do |s|
  s.version = "0.3.3"
  s.authors = ["Jason King", "Edmond Leung"]
  s.summary = %q{Makes image_tag in an ActionMailer template embed the images in the emails}

	s.files = %w{README lib/inline_attachment.rb lib/tmail_content_id.rb}

	#s.test_files       = Dir.glob('tests/*.rb')

  s.name = module_name.capitalize.gsub(/_(.)/){$1.upcase}
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date = Time.now.strftime("%Y-%m-%d")
  s.email = %q{jk@handle.it}
  s.has_rdoc = true
  s.homepage = "http://github.com/JasonKing/#{module_name}"
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = Gem::RubyGemsVersion
	s.platform         = Gem::Platform::RUBY

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 1.15"])
    else
      s.add_dependency(%q<mime-types>, [">= 1.15"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 1.15"])
  end
end

