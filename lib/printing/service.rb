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
        @soap_service = Savon::Client.new do
          wsdl.document = url
        end
      end

      def print_labels(labels, printer_name, printer_type, options={}) 
        printables = labels.map { |l| generate_printable(l, printer_type, options) }
        print(ArrayOfBarcodeLabelDTO.new(printables), printer_name, printer_type)
      end

      def generate_printable(label, printer_type,  options)
        printable = label.printable(printer_type, options)
      end

      def print(printables, printer_name, printer_type)
        begin
          response = @soap_service.request(:n1, "") do
            soap.namespaces["xmlns:n1"]= wsdl.namespace
            soap.body = { :printer => printer_name,
              :type => printer_type,
              :headerLabel =>1,
              :footerLabel => 1}.update(printables.to_soap)
            soap.input = "n1:printLabels"



            #soap.xml =<<-EOX
            xml =<<-EOX
<?xml version="1.0" encoding="UTF-8"?>
<env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:n1="urn:Barcode/Service"
xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
  <env:Body>
<n1:printLabels>
  <printer xsi:type="xsd:string">d304bc</printer>
  <type xsi:type="xsd:int">#{Layout_for_384_Wells_Plate}</type>
  <headerLabel xsi:type="xsd:boolean">true</headerLabel>
  <footerLabel xsi:type="xsd:boolean">true</footerLabel>
  <labels n2:arrayType="n1:BarcodeLabelDTO[1]" xmlns:n2="http://schemas.xmlsoap.org/soap/encoding/" xsi:type="n2:Array">
            <item> <barcode xsi:type="xsd:int">17</barcode> <desc >description</desc> <name xsi:type="xsd:string">NT 17</name> <prefix>precifx</prefix> <project>pro</project> <suffix>su</suffix> </item>
</labels> 
</n1:printLabels>
</env:Body>
</env:Envelope>
EOX
end
        rescue => ex
          raise ex

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
