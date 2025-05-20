# frozen_string_literal: true

module DoiUtilities
  class << self
    def normalize_doi(url)
      doi = Array(%r{\A(?:(http|https):/(/)?(dx\.)?(doi.org|handle.test.datacite.org)/)?(doi:)?(10\.\d{4,5}/.+)\z}
        .match(url)).last

      return if doi.blank?

      doi = doi.delete("\u200B").downcase

      "https://doi.org/#{doi}"
    end

    def uppercase_doi_from_url(url)
      if %r{\A(?:(http|https)://(dx\.)?(doi.org|handle.test.datacite.org)/)?(doi:)?(10\.\d{4,5}/.+)\z}
          .match?(url)

        uri = Addressable::URI.parse(url)

        uri.path.gsub(%r{^/}, "").upcase
      end
    end

    def doi_from_url(url)
      if %r{\A(?:(http|https)://(dx\.)?(doi.org|handle.test.datacite.org)/)?(doi:)?(10\.\d{4,5}/.+)\z}
          .match?(url)
        uri = Addressable::URI.parse(url)
        uri.path.gsub(%r{^/}, "").downcase
      end
    end
  end
end
