//
//  CPPinAnnotationView.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import "CPPinAnnotationView.h"



#pragma mark -
#pragma mark Constants
static NSString *const kCPPinAnnotationImageRed = @"red_pin";
static NSString *const kCPPinAnnotationImagePurple = @"purple_pin";
static NSString *const kCPPinAnnotationImageGreen = @"green_pin";
static CGFloat xPinBaseOffsetPercentage = 0.50f;
static CGFloat yPinBaseOffsetPercentage = 0.80f;


#pragma mark -
#pragma mark Private class extension
@interface CPPinAnnotationView ()
@property (nonatomic, retain) UIImageView *annotationImageView;

- (UIImage *)annotationImage;
@end



#pragma mark -
#pragma mark Implementation
@implementation CPPinAnnotationView
@synthesize annotationImageView = _annotationImageView;
@synthesize calloutView = _calloutView;
@synthesize pinColor = _pinColor;



- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self != nil) {        
        CGSize pinSize = self.annotationImage.size;
        self.bounds = CGRectMake(0.0f, 0.0f, pinSize.width, pinSize.height);
        self.pinColor = CPPinAnnotationColorRed;
        
        CGPoint pinPoint = CGPointMake(floorf(pinSize.width / 2.0f * xPinBaseOffsetPercentage), -1.0f * floorf(pinSize.height / 2.0f * yPinBaseOffsetPercentage));
        self.centerOffset = pinPoint;
                
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
    [_annotationImageView release];
    
    [super dealloc];
}



#pragma mark -
#pragma mark MKAnnotationView methods
- (CGPoint)calloutOffset {    
    return CGPointMake(floorf(self.centerOffset.x), 0.0f);
}

- (BOOL)canShowCallout {
    return NO; // Prevent the stock view from appearing
}



#pragma mark -
#pragma mark Setters
- (void)setPinColor:(CPPinAnnotationColor)pinColor {
    _pinColor = pinColor;
    
    [_annotationImageView removeFromSuperview];
    [_annotationImageView release];
    
    _annotationImageView = [[UIImageView alloc] initWithImage:[self annotationImage]];
    _annotationImageView.frame = self.bounds;
    
    [self addSubview:_annotationImageView];
}

- (void)setCalloutView:(UIView *)calloutView {
    if (calloutView != _calloutView) {
        [_calloutView removeFromSuperview];
        [_calloutView release];
        _calloutView = nil;
        
        _calloutView = [calloutView retain];
        [self addSubview:_calloutView];
    }
}



- (UIImage *)annotationImage {
    UIImage *image = nil;
    
    switch (_pinColor) {
        case CPPinAnnotationColorRed:
            image = [UIImage imageNamed:kCPPinAnnotationImageRed];
            break;
        case CPPinAnnotationColorGreen:
            image = [UIImage imageNamed:kCPPinAnnotationImageGreen];
            break;
        case CPPinAnnotationColorPurple:
            image = [UIImage imageNamed:kCPPinAnnotationImagePurple];
            break;
        default:
            image = [UIImage imageNamed:kCPPinAnnotationImageRed];
            break;
    }
    
    return image;
}
@end
