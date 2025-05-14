# frozen_string_literal: true

module OrcidUtilities
  class << self
    def orcid_from_url(url)
      Array(%r{\A(http|https)://orcid\.org/(.+)}.match(url)).last
    end
  end
end
