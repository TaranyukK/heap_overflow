require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { instance_double(NewAnswerService) }
  let(:answer) { create(:answer) }

  before do
    allow(NewAnswerService).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerService' do
    expect(service).to receive(:send_notification)
    described_class.perform_now(answer)
  end
end
