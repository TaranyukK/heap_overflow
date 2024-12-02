require 'rails_helper'

RSpec.describe NewAnswerService do
  let(:users) { create_list(:user, 5) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question:, user: users.last) }
  let!(:subscription) { create(:subscription, user: users.second, question:) }
  let!(:other_subscription) { create(:subscription, user: users.last, question:) }

  it 'sends new answer notification to question subscribers except the answer author' do
    allow(NewAnswerMailer).to receive(:new_answer).and_call_original

    described_class.new.send_notification(answer)

    expect(NewAnswerMailer).to have_received(:new_answer).with(answer, users.second).once
    expect(NewAnswerMailer).not_to have_received(:new_answer).with(answer, users.last)
  end
end
