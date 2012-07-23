//
//  CPCalloutAnnotation.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 23.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import "CPCalloutAnnotation.h"



@implementation CPCalloutAnnotation
@synthesize coordinate = _coordinate;



- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    
    return self;
}
@end
