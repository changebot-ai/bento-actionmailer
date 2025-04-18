require 'minitest/autorun'
require 'rails'
require 'action_mailer'
require 'bento_actionmailer'

# Suppress specific warnings from the mail gem parsers
module Warning
  class << self
    alias_method :original_warn, :warn
    # Suppress Mail gem parser 'assigned but unused variable - testEof' warnings
    def warn(message)
      if message =~ %r{/mail/parsers/.*: warning: assigned but unused variable - testEof}
        return
      end
      original_warn(message)
    end
  end
end

require 'mail'