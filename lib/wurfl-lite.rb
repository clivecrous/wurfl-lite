require 'open-uri'
require 'zlib'
require 'hpricot'
require 'amatch'

class WURFL

  class Hash < ::Hash
    def method_missing( method )
      has_key?( method ) ? self[ method ] : ( self[ :fall_back ] ? self[ :fall_back ].send( method ) : nil )
    end
  end

  def clear!
    @devices = Hash.new
    @devices_by_id = {}
  end

  def process_xml!( filename )
    data = open( filename ).read
    begin # Try decompress it, in case it's a compressed file
      # XXX Yes, this does seem ugly, but is there another way?
      data = Zlib::GzipReader.new(StringIO.new(data.to_s)).read
    rescue Zlib::GzipFile::Error
    end
    doc = Hpricot( data )

    keys_added = []

    (doc/'devices'/'device').each do |device_element|
      device = Hash.new
      %w|id user_agent fall_back|.each do |attribute|
        device[ attribute.to_sym ] = device_element.attributes[ attribute ]
      end
      (device_element/'capability').each do |capability|
        name = capability.attributes[ 'name' ].to_sym
        value = capability.attributes[ 'value' ]
        next if value.empty?
        if value.to_i.to_s == value.strip
          value = value.to_i
        elsif value.strip.downcase =~ /^(true|false)$/
          value = ( value.strip.downcase == 'true' )
        end
        device[ name ] = value
      end

      keys_added << device[ :user_agent ]
      @devices[ device[ :user_agent ] ] = device
      @devices_by_id[ device[ :id ] ] = device
    end

    keys_added.each do |key|
      @devices[ key ][ :fall_back ] = @devices_by_id[ @devices[ key ][ :fall_back ] ]
    end

  end

  def initialize( filename = 'http://downloads.sourceforge.net/project/wurfl/WURFL/latest/wurfl-latest.xml.gz' )
    clear!
    process_xml!( filename )
    process_xml!( 'http://wurfl.sourceforge.net/web_browsers_patch.xml' )
  end

  def []( user_agent )
    device = @devices[ user_agent ]
    return device if device
    match = Amatch::Sellers.new( user_agent )
    keys = @devices.keys
    distances = match.match( keys )
    use_key = keys.zip( distances ).sort{|a,b|a.last<=>b.last}.first.first
    @devices[ user_agent ] = @devices[ use_key ]
  end

end
