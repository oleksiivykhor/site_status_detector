describe SiteStatusDetector do
  before do
    allow(SiteStatusDetector::Detector).to receive(:detect)
    allow_any_instance_of(Rufus::Scheduler).to receive(:every).
      and_yield.and_yield.and_yield.and_yield.and_yield.and_yield.and_yield.
      and_yield.and_yield.and_yield.and_yield.and_yield.and_yield.and_yield
    allow_any_instance_of(Rufus::Scheduler).to receive(:join)
  end

  context 'when statuses was changed 4 times' do
    before do
      allow(SiteStatusDetector::Detector).to receive(:status_changed?).
        and_return(false, true, true, false, false, true, false, true, false)
    end

    it 'sends mail 4 times' do
      expect_any_instance_of(SiteStatusDetector::Mailer).
        to receive(:send_mail).exactly(4).times
      expect { described_class.start('', '') }.not_to raise_error
    end
  end

  context 'when statuses was not changed' do
    before do
      allow(SiteStatusDetector::Detector).to receive(:status_changed?).
        and_return(false, false, false)
    end

    it 'does not send mail' do
      expect_any_instance_of(SiteStatusDetector::Mailer).
        not_to receive(:send_mail)
      expect { described_class.start('', '') }.not_to raise_error
    end
  end
end
