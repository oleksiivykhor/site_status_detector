require './lib/site_status_detector'

desc 'starts sites status detecting'
task :start, [:urls, :email] do |t, args|
  raise ArgumentError if args[:urls].nil? || args[:email].nil?

  SiteStatusDetector.start(args[:urls].split, args[:email])
end
