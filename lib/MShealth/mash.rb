require 'hashie'

module MShealth
  class Mash < Hashie::Mash
    def initialize(hash)
      mash = super(hash)
      convert_time(mash)
      mash

    end

    private
    def convert_time(mash)
      dic = ['birthdate','last_successful_sync','day_id']
      mash.each do |k,v|
        if dic.include?(k.to_s) or k.to_s.include?("time")
          mash[k] = Time.iso8601(v)
        end
      end
    end

    protected
    def convert_key(key)
      underscore(key)
    end

    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
