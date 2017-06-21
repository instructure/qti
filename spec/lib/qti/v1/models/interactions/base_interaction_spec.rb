require 'spec_helper'

describe Qti::V1::Models::Interactions::BaseInteraction do
  let(:doc) do
    <<-XML.strip_heredoc
      <?xml version="1.0" encoding="ISO-8859-1"?>
      <questestinterop xmlns="http://www.imsglobal.org/xsd/ims_qtiasiv1p2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/ims_qtiasiv1p2 http://www.imsglobal.org/xsd/ims_qtiasiv1p2p1.xsd">
        <response_lid ident="QUE_1008_RL" rtiming="No">
        </response_lid>
      </questestinterop>
    XML
  end

  let(:node) { Nokogiri.XML(doc, &:noblanks) }

  it 'returns "Single" rcardinality by default' do
    interaction = described_class.new(node)
    expect(interaction.rcardinality).to eq 'Single'
  end
end
