require 'hashie'
require 'time'

module MShealth
  #Reference the linkedin api wrapper
  class Mash < Hashie::Mash
    def initialize(hash)
      mash = super(hash)
      convert_time(mash)
      mash

    end

    private
    def convert_time(mash)
      mash.each do |k,v|
        if k.to_s.include?("time")
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
