PutsDebuggerer.printer = lambda do |output|
  puts output
  Rails.logger.debug(output)
end
