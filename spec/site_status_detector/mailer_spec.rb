describe SiteStatusDetector::Mailer do
  let(:to) { 'test@email.com' }
  let(:statuses) { [{ url: '', status: '', message: '' }] }
  let(:mailer) { described_class.new(to) }

  it { expect(mailer.send_mail(statuses)).to be_success }

  context 'when email address are invalid' do
    let(:to) { 'invalid_email' }

    it 'raises Net::SMTPFatalError' do
      expect { mailer.send_mail(statuses) }.to raise_error Net::SMTPFatalError
    end
  end
end
