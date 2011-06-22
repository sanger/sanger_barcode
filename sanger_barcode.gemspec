# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sanger_barcode/version"

Gem::Specification.new do |s|
  s.name        = "sanger_barcode"
  s.version     = SangerBarcode::VERSION
  s.authors     = ["TODO: Write your name"]
  s.email       = ["mb14@sanger.ac.uk"]
  s.homepage    = ""
  s.summary     = %q{Gem to manage and print Sanger Barcode}
  s.description = %q{(will) provide a Barcode class
  print barcode via SOAP sanger printing barcode service
  Currently only work for ruby 1.8
}

  s.rubyforge_project = "sanger_barcode"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
