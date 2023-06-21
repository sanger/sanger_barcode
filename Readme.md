# Sanger Barcode

This repo is now archived as it is not used anymore.

This Gem provides different classes to deal with barcode and print them.

## Barcode
*to be implemented*
## Printing Service
The `Sanger::Barcode::Printing` defines 2 majors classes:, `Service` and 
`Label`.
`Service` is the main class to access the remote sanger printing service via 
SOAP.
`Label` is the basic class contrustucting a soap-struct from **Sequencescape**
information.

### Example 
```ruby
service =  Sanger::Barcode::Printing::Service.new(url) 
label = Sanger::Barcode::Printing::Label.new(:number => "123", :prefix => "NT", :study => "my study") 
service.print_labels([label], "printer 1", Layout_for_1D_tube) 
```
