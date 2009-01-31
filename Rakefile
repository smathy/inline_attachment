require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
    s.platform         = Gem::Platform::RUBY
    s.name             = "InlineAttachment"
    s.version          = "0.3.0"
    s.author           = "Edmond Leung"
    s.email            = "edmond.leung@handle.it"
    s.summary          = "A package created from a Rails patch (ticket #2179) that automatically embedded images found in your ActionMailer templates."
    s.files            = FileList['lib/*.rb', 'test/*'].to_a
    s.require_path     = "lib"
    s.autorequire      = "inline_attachment"
    s.test_files       = Dir.glob('tests/*.rb')
    s.has_rdoc         = true
    s.extra_rdoc_files = ["README"]
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end