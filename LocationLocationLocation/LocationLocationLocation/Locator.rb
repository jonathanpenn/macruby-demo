#!/usr/bin/env macruby

require 'uri'

class Locator

    attr_accessor :webView
    
    def awakeFromNib
        @locationManager = CLLocationManager.alloc.init
        @locationManager.delegate = self
        @locationManager.startUpdatingLocation
    end
        
    #
  # Callback from the CLLocationManager
  def locationManager manager, didUpdateToLocation: new, fromLocation: old
    coordinate = new.coordinate
    size = webView.bounds.size

    params = {
      markers: 'color:blue|%s,%s' % [coordinate.latitude, coordinate.longitude],
      zoom: 14,
      size: '%dx%d' % [size.width, size.height],
      sensor: 'false'
    }

    url = "http://maps.googleapis.com/maps/api/staticmap?#{encodeParams params}"

    loadUrl url
  end


  def encodeParams params
    params.map do |key, value|
      "#{URI.escape(key.to_s)}=#{URI.escape(value.to_s)}"
    end.join("&")
  end


  def loadUrl passed_url
    puts "Loading url: %s" % [passed_url]

    url = passed_url.dup

    def url.stringValue
      self
    end

    webView.takeStringURLFrom url
  end
    
end
