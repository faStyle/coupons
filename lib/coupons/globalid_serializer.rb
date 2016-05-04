module Coupons
  class GlobalidSerializer
    def self.load(attachments)
      return {} unless attachments
      attachments = JSON.load(attachments)

      attachments.each_with_object({}) do |(key, uri), buffer|
        buffer[key.to_sym] = if(!uri.nil? && uri.start_with? 'gid://')
          GlobalID::Locator
                .locate_many([uri], ignore_missing: true)
                .first
        else
          uri
        end
      end
    end

    def self.dump(attachments)
      attachments = attachments.each_with_object({}) do |(key, record), buffer|
        if record.respond_to? :to_global_id
          buffer[key] = record.to_global_id.to_s
        else
          buffer[key] = record
        end
      end

      JSON.dump(attachments)
    end
  end
end
