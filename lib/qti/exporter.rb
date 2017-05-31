module Qti
  class Exporter
    attr_reader :assessment_test, :package_root_path, :exported_file_path, :logger

    def initialize(assessment_test, args = {})
      @logger = args[:logger] || NullLogger.new
      @assessment_test = assessment_test
      @package_root_path = args[:package_root_path] || '.'
      @exported_file_path =
        File.join(File.expand_path('..', package_root_path), File.basename(export_file_name)) + '.zip'
    end

    def export
      Dir.mkdir(package_root_path) unless File.exist?(package_root_path)
      create_assessment_xml
      create_imsmanifest_xml
      export_items
      compress_package
    end

    private

    def export_file_name
      @export_file_name ||= "#{assessment_test.title.camelcase.gsub(/\s+/, '')}#{file_timestamp}"
    end

    def file_timestamp
      Time.now.utc.strftime('%Y%m%d%H%M%S')
    end

    def create_assessment_xml
      File.open(File.join(package_root_path, 'assessment.xml'), 'wb') do |f|
        f.write assessment_xml_string
      end
    end

    def assessment_xml_string
      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.assessmentTest(assesment_test_attributes(title: assessment_test.title)) do
          outcome_declarations(xml, assessment_test)
          xml.testPart do
            xml_assessment_section(xml)
          end
        end
      end.to_xml
    end

    def outcome_declarations(xml, assessment_test)
      assessment_test.outcome_declarations.each do |outcome_declaration|
        xml.outcomeDeclaration('baseType' => outcome_declaration.baseType,
                               'cardinality' => outcome_declaration.cardinality,
                               'identifier' => outcome_declaration.identifier) do
          xml.defaultValue do
            xml.value outcome_declaration.defaultValue
          end
        end
      end
    end

    def xml_assessment_section(xml)
      return if assessment_test.items.empty?
      xml.assessmentSection('identifier' => 'S1', 'visible' => 'true', 'title' => 'Section 1') do
        assessment_test.items.each do |item|
          xml.assessmentItemRef('identifier' => item.identifier, 'href' => "#{item.identifier}.xml")
        end
      end
    end

    def create_imsmanifest_xml
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.manifest(imsmanifest_attributes) do
          manifest_metadata(xml)
          manifest_resources(xml)
        end
      end

      File.open(File.join(package_root_path, 'imsmanifest.xml'), 'wb') do |f|
        f.write builder.to_xml
      end
    end

    def manifest_metadata(xml)
      xml.metadata do
        xml.schema 'QTIv2.2 Package'
        xml.schemaversion '1.0.0'
        learning_object_metadata(xml)
      end
    end

    def learning_object_metadata(xml)
      imsmd_ns = xml['imsmd']

      imsmd_ns.lom do
        imsmd_ns.general do
          imsmd_ns.identifier do
            imsmd_ns.entry 'FB-02'
          end
          imsmd_ns.title do
            imsmd_ns.string(assessment_test.title, 'language' => 'en')
          end
          imsmd_ns.language 'en'
          imsmd_ns.description do
            imsmd_ns.string('Instructure QTI package.' \
            'Feedback XML used as an example of unprocessable entity', 'language' => 'en')
          end
        end
        keywords(xml)
      end
    end

    def keywords(xml)
      keywords = %w(feedback modal test inline block)
      keywords.each do |keyword|
        xml['imsmd'].keyword do
          xml['imsmd'].string(keyword, 'language' => 'en')
        end
      end
    end

    def manifest_resources(xml)
      xml.resources do
        xml.resource('href' => 'assessment.xml', 'type' => 'imsqti_test_xmlv2p2', 'identifier' => 'TEST') do
          xml.file('href' => 'assessment.xml')
          assessment_test.items.each do |item|
            xml.file('href' => "#{item.identifier}.xml")
          end
        end
      end
    end

    def export_items
      assessment_test.items.each do |assessment_item|
        Qti::AssessmentItemExporter.new(assessment_item, package_root_path: package_root_path).export
      end
    end

    def assesment_test_attributes(args = {})
      { 'xmlns' => 'http://www.imsglobal.org/xsd/imsqti_v2p2', 'xmlns:xi' => 'http://www.w3.org/2001/XInclude',
        'xmlns:m' => 'http://www.w3.org/1998/Math/MathML', 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://www.imsglobal.org/xsd/imsqti_v2p2 ' \
        'http://www.imsglobal.org/xsd/qti/qtiv2p2/imsqti_v2p2.xsd' }.merge(args)
    end

    def imsmanifest_attributes
      { 'xmlns' => 'http://www.imsglobal.org/xsd/imscp_v1p1', 'xmlns:imsmd' => 'http://ltsc.ieee.org/xsd/LOM',
        'xmlns:imsqti' => 'http://www.imsglobal.org/xsd/imsqti_v2p2', 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://www.imsglobal.org/xsd/imscp_v1p1 ' \
                                'http://www.imsglobal.org/xsd/qti/qtiv2p2/qtiv2p2_imscpv1p2_v1p0.xsd' \
                                'http://ltsc.ieee.org/xsd/LOM http://www.imsglobal.org/xsd/imsmd_loose_v1p3p2.xsd' \
                                'http://www.imsglobal.org/xsd/imsqti_metadata_v2p2' \
                                'http://www.imsglobal.org/xsd/qti/qtiv2p2/imsqti_metadata_v2p2.xsd' }
    end

    def compress_package
      Zip::File.open(exported_file_path, 'w') do |zipfile|
        add_all_files(zipfile, package_root_path)
      end

      FileUtils.rm_rf(package_root_path)
      exported_file_path
    end

    def add_all_files(zipfile, package_root_path)
      Dir["#{package_root_path}/**/**"].each do |file|
        begin
          entry = file.sub(package_root_path + '/', '')
          zipfile.add(entry, file)
        rescue Zip::EntryExistsError
          logger.info("#{file} already exists")
        end
      end
    end
  end
end
