//
//  CPCalloutAnnotation.h
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 23.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>



@interface CPCalloutAnnotation : NSObject <MKAnnotation> {
@private
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
