//
//  CPAnnotation.h
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>



@interface CPAnnotation : NSObject <MKAnnotation> {
@private
    CLLocationCoordinate2D _coordinate;
 
    NSString *_title;
    NSString *_subtitle;
    NSArray *_images;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSArray *images;

@end
