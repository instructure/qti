require 'rspec/expectations'

RSpec::Matchers.define :have_file_content do |expected|
  match do |actual|
    File.read(actual) == expected
  end
end

RSpec::Matchers.define :contain_zip_entry do |entry|
  match do |file_path|
    zip_entry = Zip::File.open(file_path) do |zip_file|
      zip_file.glob(entry).first
    end
    expect(zip_entry).to be_present
  end
end

RSpec::Matchers.define :have_zip_entry do |entry|
  match do |file_path|
    expect(file_content_in_zip_file(file_path, entry)).to eq(@expected_content)
  end

  failure_message do |file_path|
    c = file_content_in_zip_file(file_path, entry)
    if c.empty?
      "expect #{file_path} to contain an entry #{entry}"
    elsif c != @expected_content
      RSpec::Support::Differ.new.diff(c, @expected_content)
    end
  end

  def file_content_in_zip_file(file_path, entry)
    Zip::File.open(file_path) do |zip_file|
      e = zip_file.glob(entry).first
      e.get_input_stream.read
    end
  end

  chain :with_content do |expected_content|
    @expected_content = expected_content
  end
end
