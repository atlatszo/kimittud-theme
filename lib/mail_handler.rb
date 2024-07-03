module MailHandler
  module Utf8Patch
    def get_attachment_text_one_file(*args)
      convert_string_to_utf8(super, 'UTF-8').string
    end
  end

  prepend Utf8Patch
end

