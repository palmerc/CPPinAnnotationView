//
//  CPPinAnnotationView.h
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import <MapKit/MapKit.h>



typedef enum {
    CPPinAnnotationColorRed,
    CPPinAnnotationColorPurple,
    CPPinAnnotationColorGreen
} CPPinAnnotationColor;

@interface CPPinAnnotationView : MKAnnotationView {
@private
    UIImageView *_annotationImageView;
    UIView *_calloutView;
        
    CPPinAnnotationColor _pinColor;
}

@property (nonatomic, assign) CPPinAnnotationColor pinColor;
@property (nonatomic, retain) UIView *calloutView;

@end
