module MailHandler
  module Utf8Patch
    def get_attachment_text_one_file(*args)
      super.scrub
    end
  end

  prepend Utf8Patch
end

