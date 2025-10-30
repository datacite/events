# frozen_string_literal: true

require "rails_helper"

RSpec.describe(SqsUtilities) do
  let(:sqs_client) { instance_double(Aws::SQS::Client) }

  before do
    allow(Aws::SQS::Client).to(receive(:new).and_return(sqs_client))

    allow(ENV).to(receive(:[]).and_call_original)

    allow(ENV).to(receive(:[]).with("SQS_PREFIX").and_return("test"))

    allow(ENV).to(receive(:[]).with("AWS_ENDPOINT").and_return("http://aws.fake.com"))

    allow(sqs_client).to(receive(:send_message))
  end

  describe "#send_events_other_doi_job_message" do
    let(:data) { { subj_id: "subj_id", obj_id: "obj_id" } }
    let(:queue_url) { "https://sqs.fake.aws/test_events_other_doi_job" }

    before do
      allow(sqs_client)
        .to(receive(:get_queue_url)
        .and_return(instance_double(Aws::SQS::Types::GetQueueUrlResult, queue_url: queue_url)))
    end

    describe "when in development" do
      before do
        allow(Rails.env).to(receive(:development?).and_return(true))
      end

      it "calls send_message with correct params" do
        described_class.send_events_other_doi_job_message(data)

        expect(sqs_client).to(have_received(:send_message).with(
          hash_including(
            queue_url: queue_url,
            message_attributes: hash_including(
              "shoryuken_class" => hash_including(string_value: "OtherDoiJob"),
            ),
            message_body: data.to_json,
          ),
        ))
      end
    end

    describe "when not in development" do
      before do
        allow(Rails.env).to(receive(:development?).and_return(false))
      end

      it "calls send_message with correct params" do
        described_class.send_events_other_doi_job_message(data)

        expect(sqs_client).to(have_received(:send_message).with(
          hash_including(
            queue_url: queue_url,
            message_attributes: hash_including(
              "shoryuken_class" => hash_including(string_value: "OtherDoiJob"),
            ),
            message_body: data.to_json,
          ),
        ))
      end
    end

    describe "when SQS send fails" do
      before do
        allow(Rails.logger).to(receive(:error))
        allow(sqs_client).to(receive(:send_message).and_raise(StandardError, "Oops"))
      end

      it "logs an error" do
        described_class.send_events_other_doi_job_message(data)
        expect(Rails.logger).to(have_received(:error))
      end
    end
  end
end
