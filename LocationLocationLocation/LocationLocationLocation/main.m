//
//  main.m
//  LocationLocationLocation
//
//  Created by Jonathan Penn on 11/30/11.
//  Copyright (c) 2011 Navel Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
