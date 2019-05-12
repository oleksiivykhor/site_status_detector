describe SiteStatusDetector::Detector do
  describe '.detect' do
    let(:url) { 'https://www.facebook.com' }
    let(:urls) { [url, url, url] }
    let(:results) do
      urls.map do |url|
        { url: url, status: '200', message: 'OK' }
      end
    end

    it 'detects site status' do
      expect(described_class.detect(urls)).to eq results
    end

    context 'when site status 301' do
      let(:url) { 'https://google.com' }
      let(:results) { [{ status: '302', message: 'Found', url: url }] }

      it 'returns correct status and message' do
        expect(described_class.detect([url])).to eq results
      end
    end

    context 'when exception was raised' do
      before do
        allow(Net::HTTP).to receive(:get_response).and_raise exception
      end

      context 'when Errno::ECONNREFUSED' do
        let(:exception) { Errno::ECONNREFUSED }
        let(:error) { 'Connection refused' }

        it 'returns error message' do
          expect(described_class.detect(urls)[0][:message]).to eq error
        end
      end

      context 'when Net::OpenTimeout' do
        let(:exception) { Net::OpenTimeout }
        let(:error) { 'Net::OpenTimeout' }

        it 'returns error message' do
          expect(described_class.detect(urls)[0][:message]).to eq error
        end
      end

      context 'when SocketError' do
        let(:exception) { SocketError }
        let(:error) { 'SocketError' }

        it 'returns error message' do
          expect(described_class.detect(urls)[0][:message]).to eq error
        end
      end
    end
  end

  describe '.status_changed?' do
    context 'when file does not exist yet' do
      before do
        allow(File).to receive(:read).and_raise Errno::ENOENT
        allow(described_class).to receive_message_chain(:get_statuses, :all?).
          and_return(true)
      end

      it 'checks current statuses for 200 code and stores statuses' do
        expect(described_class).to receive(:store_statuses).at_least(:once)
        expect(described_class.status_changed?([])).to be_falsey
      end
    end
  end
end
