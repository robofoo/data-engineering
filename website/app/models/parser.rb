module Parser
  extend self

  def process(uploaded_io, file_path)
    save_file(uploaded_io, file_path)
  end

  def save_file(uploaded_io, file_path)
    File.open(file_path, 'w') do |file|
      file.write(uploaded_io.read)
    end
  end
end
