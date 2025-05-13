# frozen_string_literal: true

module DoiUtilities
  def self.normalize_doi(url)
    doi =
      Array(%r{\A(?:(http|https):/(/)?(dx\.)?(doi.org|handle.test.datacite.org)/)?(doi:)?(10\.\d{4,5}/.+)\z}
      .match(doi)).last

    doi = doi.delete("\u200B").downcase if doi.present?

    "https://doi.org/#{doi}" if doi.present?
  end

  def self.uppercase_doi_from_url(url)
    if %r{\A(?:(http|https)://(dx\.)?(doi.org|handle.test.datacite.org)/)?(doi:)?(10\.\d{4,5}/.+)\z}
        .match?(url)

      uri = Addressable::URI.parse(url)

      uri.path.gsub(%r{^/}, "").upcase
    end
  end
end
