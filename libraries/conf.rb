# encoding: UTF-8

module MumbleServer
  # Method helpers to be used from configuration templates
  module Conf
    def self.key(k)
      k.to_s
    end

    def self.value(v)
      # * Use True and False as booleans.
      # * Make sure to quote the value when using commas in strings or
      #   passwords.
      #    NOT variable = super,secret BUT variable = "super,secret"
      # * Make sure to escape special characters like '\' or '"' correctly
      #    NOT variable = """ BUT variable = "\""
      #    NOT regex = \w* BUT regex = \\w*
      v = [true, false].include?(v) ? v.to_s.capitalize : v.to_s
      v = v.gsub(/([\\"])/) { "\\#{Regexp.last_match(0)}" }
      v = "\"#{v}\"" if v.include?(',') && v[0] != '"' && v[-1] != '"'
      v
    end

    def self.key_value(k, v)
      "#{key(k)}=#{value(v)}"
    end

    def self.sort(values)
      # Ice section has to be last in the configuration file:
      values = values.to_hash
      ice = values.delete('Ice')
      values['Ice'] = ice
      values
    end
  end
end
