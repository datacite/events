# frozen_string_literal: true

require "git"
module Events
  class Application
    begin
      if File.directory?(Rails.root.join(".git"))
        g = Git.open(Rails.root)
        VERSION = g.tags.map { |t| Gem::Version.new(t.name) }.max.to_s
        REVISION = g.object("HEAD").sha
      else
        VERSION = "unknown"
        REVISION = "unknown"
      end
    rescue => _
      VERSION = "unknown"
      REVISION = "unknown"
    end
  end
end
