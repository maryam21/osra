class ExcelUpload
  class ExcelImportError < StandardError
  end
  def self.upload(file, first_row)
    case file
      when String
        name = file
        path = file
      when Rack::Test::UploadedFile, ActionDispatch::Http::UploadedFile
        name = file.original_filename
        path = file.path
    end
    begin
      doc = Roo::Spreadsheet.open path, extension: extension(name)
    rescue => e
      raise ExcelImportError, 'Is not a valid Excel file. ' + e.to_s
    end
    if empty_file?(doc, first_row)
      raise ExcelImportError, 'Does not contain any orphan records'
    end
    doc
  end

  def self.extension(file)
    file =~ /[.]([^.]+)\z/
    $1.to_s
  end

  def self.empty_file?(doc, first_row)
    doc.last_row.nil? || doc.last_row < first_row
  end
end
