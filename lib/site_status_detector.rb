require 'byebug'
require 'net/http'
require 'net/smtp'
require 'yaml'
require 'pathname'
require 'rufus-scheduler'

module SiteStatusDetector
  def self.root
    Pathname.new File.expand_path('../', __dir__)
  end

  def self.start(urls, email)
    scheduler = Rufus::Scheduler.new
    mailer = SiteStatusDetector::Mailer.new email
    detector = SiteStatusDetector::Detector
    scheduler.every '1m' do
      statuses = detector.detect urls
      message = 'Checked. '
      if detector.status_changed? statuses
        mailer.send_mail statuses
        message += 'Mail sent.'
      end
      puts message
    end
    scheduler.join
  end
end

require SiteStatusDetector.root.join 'lib/site_status_detector/mailer'
require SiteStatusDetector.root.join 'lib/site_status_detector/detector'
