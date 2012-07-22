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
@property (nonatomic, retain, readonly) UIImage *image;
@end



#pragma mark -
#pragma mark Implementation
@implementation CPPinAnnotationView
@synthesize image = _image;
@synthesize animatesDrop = _animatesDrop;
@synthesize pinColor = _pinColor;


- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pinColor = CPPinAnnotationColorRed;
        
        CGSize pinSize = self.image.size;
        self.bounds = CGRectMake(0.0f, 0.0f, pinSize.width, pinSize.height);
        self.centerOffset = CGPointMake(floorf(pinSize.width / 2.0f * xPinBaseOffsetPercentage), -1.0f * floorf(pinSize.height / 2.0f * yPinBaseOffsetPercentage));
        self.calloutOffset = CGPointMake(floorf(pinSize.width * xPinBaseOffsetPercentage - pinSize.width / 2.0f), 0.0f);
        NSLog(@"Center Offset - %f, %f", self.centerOffset.x, self.centerOffset.y);
        NSLog(@"Callout Offset - %f, %f", self.calloutOffset.x, self.calloutOffset.y);

        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.25];
    }
    return self;
}

- (void)dealloc {
    [_image release];    
    
    [super dealloc];
}

- (void)layoutSubviews {
    NSLog(@"layout");
}




- (void)drawRect:(CGRect)rect {
    CGRect pinRect = rect;
  
    [self.image drawInRect:pinRect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    NSString *state = nil;
    if (selected) {
        state = @"Selected";
        
//        BOOL isFinished = NO;
//        UIView *view = self;
//        while (!isFinished) {
//            if ([view isMemberOfClass:[MKMapView class]]) {
//                isFinished = YES;
//            } else {
//                view = [view superview];
//            }
//        }
        
//        CGPoint point = [self convertPoint:self.frame.origin toView:view];
        NSLog(@"Center - %f, %f", self.center.x, self.center.y);
        NSLog(@"Center Offset - %f, %f", self.centerOffset.x, self.centerOffset.y);
        NSLog(@"Callout Offset - %f, %f", self.calloutOffset.x, self.calloutOffset.y);
        
        
        CGRect calloutOffset = CGRectMake(self.centerOffset.x - 50.0f, self.centerOffset.y - 50.0f - self.bounds.size.height + (self.bounds.size.height / 2.0f * (1.0f - yPinBaseOffsetPercentage)), 100.0f, 100.0f);
        _calloutView = [[CPPinCalloutView alloc] initWithFrame:calloutOffset];
        _calloutView.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:0.25f];
            
        [self addSubview:_calloutView];
        
    } else {
        state = @"Deselected";
        
        [_calloutView removeFromSuperview];
    }
    NSLog(@"State: %@", state);
}



- (BOOL)canShowCallout {
    return NO; // Prevent the stock view from appearing
}



- (UIImage *)image {
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


- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL respondsToSelector = [super respondsToSelector:aSelector];
    
    NSLog(@"Responds To Selector - %@", NSStringFromSelector(aSelector));
    
    return respondsToSelector;
}

@end
