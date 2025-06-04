# frozen_string_literal: true

require "rails_helper"

RSpec.describe(EventIndexJob, type: :job) do
  let(:event) { build(:event) }

  before do
    allow(Rails.logger).to(receive(:error))
  end

  describe ".shoryuken_options" do
    it "uses the correct queue name" do
      queue_name = "#{ENV["RAILS_ENV"]}_events_index"

      expect { described_class.perform_later({}) }
        .to(have_enqueued_job(described_class).on_queue(queue_name))
    end
  end

  describe "rescue_from" do
    describe "ActiveJob::DeserializationError" do
      let(:error) { ActiveJob::DeserializationError.allocate }

      before do
        allow(error).to(receive(:message).and_return("ActiveJob::DeserializationError"))

        allow(event.__elasticsearch__)
          .to(receive(:index_document)
              .and_raise(error))
      end

      it "rescues the error" do
        expect { described_class.perform_now(event) }.not_to(raise_error)
      end

      it "logs the error" do
        described_class.perform_now(event)

        expect(Rails.logger).to(have_received(:error).with("ActiveJob::DeserializationError"))
      end
    end

    describe "SocketError" do
      let(:error) { SocketError.allocate }

      before do
        allow(error).to(receive(:message).and_return("SocketError"))

        allow(event.__elasticsearch__)
          .to(receive(:index_document)
              .and_raise(error))
      end

      it "rescues the error" do
        expect { described_class.perform_now(event) }.not_to(raise_error)
      end

      it "logs the error" do
        described_class.perform_now(event)

        expect(Rails.logger).to(have_received(:error).with("SocketError"))
      end
    end

    describe "Elasticsearch::Transport::Transport::Errors::BadRequest" do
      let(:error) { Elasticsearch::Transport::Transport::Errors::BadRequest.allocate }

      before do
        allow(error).to(receive(:message).and_return("Elasticsearch::Transport::Transport::Errors::BadRequest"))

        allow(event.__elasticsearch__)
          .to(receive(:index_document)
              .and_raise(error))
      end

      it "rescues the error" do
        expect { described_class.perform_now(event) }.not_to(raise_error)
      end

      it "logs the error" do
        described_class.perform_now(event)

        expect(Rails.logger).to(have_received(:error).with("Elasticsearch::Transport::Transport::Errors::BadRequest"))
      end
    end

    describe "Elasticsearch::Transport::Transport::Error" do
      let(:error) { SocketError.allocate }

      before do
        allow(error).to(receive(:message).and_return("Elasticsearch::Transport::Transport::Error"))

        allow(event.__elasticsearch__)
          .to(receive(:index_document)
              .and_raise(error))
      end

      it "rescues the error" do
        expect { described_class.perform_now(event) }.not_to(raise_error)
      end

      it "logs the error" do
        described_class.perform_now(event)

        expect(Rails.logger).to(have_received(:error).with("Elasticsearch::Transport::Transport::Error"))
      end
    end
  end

  describe ".perform" do
    it "logs the indexing attempt" do
      allow(Rails.logger).to(receive(:info))

      allow(event.__elasticsearch__).to(receive(:index_document).and_return("result" => "created"))

      described_class.perform_now(event)

      expect(Rails.logger)
        .to(have_received(:info)
          .with("[Events:EventIndexJob] Indexing event: #{event.uuid} in OpenSearch"))
    end

    it "attempts to index an event" do
      allow(event.__elasticsearch__).to(receive(:index_document).and_return("result" => "created"))

      described_class.perform_now(event)

      expect(event.__elasticsearch__).to(have_received(:index_document).once)
    end

    it "when indexing successfully creates an event document logs an info message" do
      allow(Rails.logger).to(receive(:info))

      allow(event.__elasticsearch__).to(receive(:index_document).and_return("result" => "created"))

      described_class.perform_now(event)

      expect(Rails.logger)
        .to(have_received(:info)
          .with("[Events:EventIndexJob] Successfully indexed event: #{event.uuid} in OpenSearch"))
    end

    it "when indexing successfully updates an event document does not log error" do
      allow(event.__elasticsearch__).to(receive(:index_document).and_return("result" => "updated"))

      described_class.perform_now(event)

      expect(Rails.logger).not_to(have_received(:error))
    end

    it "when indexing is unsuccessful we log the error" do
      allow(event.__elasticsearch__).to(receive(:index_document).and_return("result" => "failed"))

      described_class.perform_now(event)

      expect(Rails.logger).to(have_received(:error))
    end
  end
end
