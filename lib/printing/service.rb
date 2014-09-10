require 'printing/barcode_exception'
require 'printing/barcode_wsdl'
require 'savon'

module Sanger::Barcode
  module Printing
    #Layout , or printer type id
    Layout_for_1D_tube = 2
    Layout_for_96_Wells_Plate = 1
    Layout_for_384_Wells_Plate = 6

    class Service
      def initialize(url)
        @url = url
        begin
          @soap_service = Savon::Client.new do
            wsdl.document = url
          end
        rescue  => ex
          raise BarcodeException, "error when trying to connect to service '#{url}', [#{ex}]"
        end
      end

      def generate_printable(label, printer_type,  options)
        printable = label.printable(printer_type, options)
      end

      def print_labels(labels, printer_name, printer_type, options={})
        printables = labels.map { |l| generate_printable(l, printer_type, options) }
        begin
          response = @soap_service.request(:n1, "") do
            soap.namespaces["xmlns:n1"]= wsdl.namespace
            soap.body = { :printer => printer_name,
              :type => printer_type,
              :headerLabel =>1,
              :footerLabel => 1 ,
              :labels => { :item => printables.map {|e| e.to_soap } }  ,
              :attributes! => {
                :labels => {
                  "n2:arrayType" =>  "n1:BarcodeLabelDTO[#{printables.size}]",
                  "xmlns:n2" => "http://schemas.xmlsoap.org/soap/encoding/",
                  "xsi:type"=>"n2:Array"
                    }
              }
            }
            soap.input = "n1:printLabels"
          end
        rescue Savon::SOAP::Fault=> ex
          raise BarcodeException, "problem in the soap '#{ex}'"
        rescue Savon::HTTP::Error 
          raise BarcodeException, "problem connecting to Barcode service", caller
        end
      end
      def verify(number)
        raise NotImplemented
        response = service.verifyNumber(number.to_s)
        response.process == 'Good'
      end
    end
  end
end
