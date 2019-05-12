module SiteStatusDetector
  class Detector
    class << self
      # Detects site status
      #
      # @param urls [Array]
      # @return [Array] hashes with status codes and messages
      def detect(urls)
        urls.each_with_object([]) do |url, results|
          response = Net::HTTP.get_response(URI(url))
          results << { url: url, status: response.code,
                       message: response.message }
        rescue Errno::ECONNREFUSED, Net::OpenTimeout, SocketError => error
          results << { message: error.message, status: '404', url: url }
        end
      end

      def status_changed?(statuses)
        prev_statuses = File.read(statuses_path).split(' ')
        prev_statuses != get_statuses(statuses)
      rescue Errno::ENOENT
        # When file does not exist yet (the first execution) we store statuses
        # and check if all statuses 200
        store_statuses statuses

        !get_statuses(statuses).all? { |s| s.eql?('200') }
      ensure
        store_statuses statuses
      end

      private

      def get_statuses(statuses)
        statuses.map { |s| s[:status] }
      end

      def store_statuses(statuses)
        File.open(statuses_path, 'w') do |file|
          file.write get_statuses(statuses).join(' ')
        end
      end

      def statuses_path
        SiteStatusDetector.root.join('tmp/previous_statuses.txt')
      end
    end
  end
end
