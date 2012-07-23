//
//  CPPinAnnotationView.h
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "CPCalloutAnnotation.h"



typedef enum {
    CPPinAnnotationColorRed,
    CPPinAnnotationColorPurple,
    CPPinAnnotationColorGreen
} CPPinAnnotationColor;

@interface CPPinAnnotationView : MKAnnotationView {
@private
    UIImage *_image;
    CPCalloutAnnotation *_calloutAnnotation;
        
    CPPinAnnotationColor _pinColor;
}

@property (nonatomic, retain) CPCalloutAnnotation *calloutAnnotation;
@property (nonatomic, assign) CPPinAnnotationColor pinColor;

@end
