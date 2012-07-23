//
//  CPPinCalloutView.h
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@interface CPCalloutAnnotationView : MKAnnotationView {
@private
	UIView *_contentView;
    
    CGPoint _calloutOffset;
    
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
    CGRect _endFrame;
    
    CGFloat _strokeWidth;
	CGFloat _cornerRadius;
    CGFloat _calloutInset;
    CGFloat _triangleWidth;
    CGFloat _triangleHeight;
    CGSize _shadowOffset;
    CGFloat _shadowBlur;
    UIColor *_baseColor;
    UIColor *_shadowColor;
    UIColor *_borderColor;
    
    BOOL _shineEnabled;
    BOOL _isVisible;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;

@property (nonatomic, assign) CGPoint calloutOffset;

@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat calloutInset;
@property (nonatomic, assign) CGFloat triangleWidth;
@property (nonatomic, assign) CGFloat triangleHeight;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, retain) UIColor *baseColor;
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign, getter=isShineEnabled) BOOL shineEnabled;

- (void)animateCalloutAppearance;
- (void)animateCalloutDisappearance;

@end
