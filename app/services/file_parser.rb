class FileParser
  attr_reader :path
  def initialize(path: path)
    @path = path
  end

  def build_formatted_results
    result = {}
    File.foreach(path) do |event|
      day, small, medium, large = event.strip.split(",").map(&:to_i)
      days = []
      size_hash = {small: small, medium: medium, large: large}

      if result[day]
        result[day] << size_hash
      else
        result[day] = [size_hash]
      end
    end
    result
  end
end
