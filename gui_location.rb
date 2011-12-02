#!/usr/bin/env macruby

framework 'AppKit'
framework 'CoreLocation'
framework 'WebKit'

require 'uri'

class AppDelegate

  # Callback from NSApplication
  def applicationDidFinishLaunching notification
    setupWindow
    setupWebView
    startGrabbingLocation
  end

  # Callback from NSWindow
  def windowWillClose notification
    exit
  end


private

  def setupWindow
    @window = NSWindow.alloc.initWithContentRect(
      [10, 200, 600, 400],
      styleMask: NSTitledWindowMask|NSClosableWindowMask,
      backing: NSBackingStoreBuffered,
      defer:false)

    @window.title = "Your Current Location"
    @window.level = NSModalPanelWindowLevel
    @window.delegate = self
    @window.display
    @window.orderFrontRegardless
  end

  def setupWebView
    @webView = WebView.alloc.initWithFrame(
      @window.contentView.bounds,
      frameName: nil,
      groupName: nil)

    @window.contentView.addSubview @webView
  end

  def startGrabbingLocation
    @locationManager = CLLocationManager.alloc.init
    @locationManager.delegate = self
    @locationManager.startUpdatingLocation
  end


  # Callback from the CLLocationManager
  def locationManager manager, didUpdateToLocation: new, fromLocation: old
    coordinate = new.coordinate
    size = @webView.bounds.size

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

    @webView.takeStringURLFrom url
  end

end


app = NSApplication.sharedApplication
app.delegate = AppDelegate.new
app.run

