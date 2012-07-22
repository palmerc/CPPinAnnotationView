//
//  CPPinAnnotationView.h
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "CPPinCalloutView.h"



typedef enum {
    CPPinAnnotationColorRed,
    CPPinAnnotationColorPurple,
    CPPinAnnotationColorGreen
} CPPinAnnotationColor;

@interface CPPinAnnotationView : MKAnnotationView {
@private
    UIImage *_image;
    
    CPPinCalloutView *_calloutView;
    
    BOOL _canShowCallout;
    BOOL _animatesDrop;
    CPPinAnnotationColor _pinColor;
}

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, assign, getter=isAnimatesDrop) BOOL animatesDrop;
@property (nonatomic, assign) CPPinAnnotationColor pinColor;



@end
