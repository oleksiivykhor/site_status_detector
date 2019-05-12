module SiteStatusDetector
  class Mailer
    DOMAIN = 'gmail.com'.freeze

    def initialize(to)
      @username = credentials['username']
      @password = credentials['password']
      @to = to
      smtp.start(DOMAIN, @username, @password, :login)
    end

    def send_mail(statuses)
      smtp.send_message mail(statuses), @username, @to
    end

    at_exit { smtp.finish }

    private

    def credentials
      YAML.load_file(SiteStatusDetector.root.join('.gmail_credentials.yml'))
    end

    def smtp
      @smtp ||= Net::SMTP.new "smtp.#{DOMAIN}", 587
      @smtp.enable_starttls
      @smtp
    end

    def mail(statuses)
      <<~MAIL
        From: SiteStatusDetector <#{@username}>
        To: #{@to}
        MIME-Version: 1.0
        Content-type: text/html
        Subject: Site Status Change

        <h3>You received this email because status of site(s) was changed<h3>

        <div>#{content(statuses)}</div>
      MAIL
    end

    def content(statuses)
      content = '<ul>'
      statuses.each do |status|
        content += "<li><ul><li>URL: #{status[:url]}</li>"\
          "<li>CODE: #{status[:status]}</li>"\
          "<li>MESSAGE: #{status[:message]}</li></ul></li><br>"
      end
      content += '</ul>'
    end
  end
end
