require 'soap/wsdlDriver'
require 'printing/barcode_exception'
require 'printing/barcode_wsdl'

module Sanger::Barcode
  module Printing
    #Layout , or printer type id
    Layout_for_1D_tube = 2
    Layout_for_96_Wells_Plate = 1
    Layout_for_384_Wells_Plate = 6

    class Service
      def initialize(url)
        @url = url
        @soap_service = SOAP::WSDLDriverFactory.new(url).create_rpc_driver
      end

      def print_labels(labels, printer_name, printer_type, options={}) 
        printables = labels.map { |l| generate_printable(l, printer_type, options) }
        print(printables, printer_name, printer_type)
      end

      def generate_printable(label, printer_type,  options)
        printable = label.printable(printer_type, options)
      end

      def print(printables, printer_name, printer_type)
        begin
          result = @soap_service.printLabels(printer_name, printer_type, 1, 1, printables)
        rescue SOAP::HTTPStreamError
          raise BarcodeException, "problem connecting to Barcode service", caller
        end
      end
      def verify(number)
        response = service.verifyNumber(number.to_s)
        response.process == 'Good'
      end
    end
  end
end
