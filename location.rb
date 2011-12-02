#!/usr/bin/env macruby

WAIT_TIME_FOR_ACCURACY = 40 # seconds

framework 'AppKit'
framework 'CoreLocation'

puts "Getting location multiple times to increase accuracy..."

locationManager = CLLocationManager.alloc.init
locationManager.delegate = self

def locationManager manager, didUpdateToLocation: new, fromLocation: old
  print "location: #{new.description}"
  puts ", timestamp: #{new.timestamp.timeIntervalSinceNow}"
end

locationManager.startUpdatingLocation

endDate = NSDate.dateWithTimeIntervalSinceNow(WAIT_TIME_FOR_ACCURACY)
NSRunLoop.currentRunLoop.runUntilDate(endDate)

