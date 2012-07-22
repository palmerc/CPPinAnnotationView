//
//  CPPinCalloutView.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//



#import "CPPinCalloutView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#define CalloutMapAnnotationViewBottomShadowBufferSize 6.0f
#define CalloutMapAnnotationViewContentHeightBuffer 8.0f
#define CalloutMapAnnotationViewHeightAboveParent 13.0f
#define CalloutMapAnnotationViewInset 4.0f



#pragma mark -
#pragma mark Private Category
@interface CPPinCalloutView()
@property (nonatomic, readonly) CGFloat yShadowOffset;
@property (nonatomic) CGRect endFrame;

- (void)animateCalloutAppearance;
- (void)animateCalloutDisappearance;
@end



#pragma mark -
#pragma mark Implementation
@implementation CPPinCalloutView
@synthesize contentView = _contentView;
@synthesize endFrame = _endFrame;
@synthesize yShadowOffset = _yShadowOffset;
@synthesize strokeWidth = _strokeWidth;
@synthesize cornerRadius = _cornerRadius;
@synthesize calloutInset = _calloutInset;
@synthesize triangleWidth = _triangleWidth;
@synthesize triangleHeight = _triangleHeight;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowBlur = _shadowBlur;
@synthesize baseColor = _baseColor;
@synthesize shadowColor = _shadowColor;
@synthesize borderColor = _borderColor;
@synthesize shineEnabled = _shineEnabled;



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
		self.backgroundColor = [UIColor clearColor];
        self.baseColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        self.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.borderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.9f];
        
        _strokeWidth = 1.0f;
        _cornerRadius = 8.0f;
        _calloutInset = 7.0f;
        _triangleWidth = 30.0f;
        _triangleHeight = 15.0f;
        _shadowOffset = CGSizeMake(0, self.yShadowOffset);
        _shadowBlur = 6.0f;
        
        _shineEnabled = YES;
	}
    
	return self;
}

- (void)dealloc {
    [_baseColor release];
    [_shadowColor release];
    [_borderColor release];
    
    [_parentAnnotationView release];
    [_mapView release];
	[_contentView release];
    
    [super dealloc];
}



- (void)drawRect:(CGRect)rect {
    CGRect calloutRect = rect;
    
	CGMutablePathRef path = CGPathCreateMutable();
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat parentX = [self relativeParentXPosition];
	
	//Determine Size
	calloutRect = self.bounds;
	calloutRect.size.width -= _strokeWidth + 2.0f * _calloutInset;
	calloutRect.size.height -= _strokeWidth + _triangleHeight + 2.0f * _calloutInset;
	calloutRect.origin.x += _strokeWidth / 2.0f + _calloutInset;
	calloutRect.origin.y += _strokeWidth / 2.0f + _calloutInset;
    
	//Create Path For Callout Bubble
    BOOL clockwise = YES;
	CGPathMoveToPoint(path, NULL, calloutRect.origin.x, calloutRect.origin.y + _cornerRadius);
	CGPathAddLineToPoint(path, NULL, calloutRect.origin.x, calloutRect.origin.y + calloutRect.size.height - _cornerRadius);
	CGPathAddArc(path, NULL, calloutRect.origin.x + _cornerRadius, calloutRect.origin.y + calloutRect.size.height - _cornerRadius, _cornerRadius, M_PI, M_PI / 2.0f, clockwise);
    
    // The callout triangle below the box
	CGPathAddLineToPoint(path, NULL, parentX - _triangleWidth / 2.0f, calloutRect.origin.y + calloutRect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, calloutRect.origin.y + calloutRect.size.height + _triangleHeight);
    CGPathAddLineToPoint(path, NULL, parentX + _triangleWidth / 2.0f, calloutRect.origin.y + calloutRect.size.height);
    
	CGPathAddLineToPoint(path, NULL, calloutRect.origin.x + calloutRect.size.width - _cornerRadius, calloutRect.origin.y + calloutRect.size.height);
	CGPathAddArc(path, NULL, calloutRect.origin.x + calloutRect.size.width - _cornerRadius, calloutRect.origin.y + calloutRect.size.height - _cornerRadius, _cornerRadius, M_PI / 2.0f, 0.0f, clockwise);
	CGPathAddLineToPoint(path, NULL, calloutRect.origin.x + calloutRect.size.width, calloutRect.origin.y + _cornerRadius);
	CGPathAddArc(path, NULL, calloutRect.origin.x + calloutRect.size.width - _cornerRadius, calloutRect.origin.y + _cornerRadius, _cornerRadius, 0.0f, -M_PI / 2.0f, clockwise);
	CGPathAddLineToPoint(path, NULL, calloutRect.origin.x + _cornerRadius, calloutRect.origin.y);
	CGPathAddArc(path, NULL, calloutRect.origin.x + _cornerRadius, calloutRect.origin.y + _cornerRadius, _cornerRadius, -M_PI / 2.0f, M_PI, clockwise);
	CGPathCloseSubpath(path);
	
	//Fill Callout Bubble & Add Shadow
	[_baseColor setFill];
    
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
    
    if (_shadowColor != nil) {
        CGContextSetShadowWithColor(context, _shadowOffset, _shadowBlur, _shadowColor.CGColor);
	}
    
    CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	//Stroke Callout Bubble
    if (_borderColor != nil) {
        [_borderColor setStroke];
        CGContextSetLineWidth(context, _strokeWidth);
        CGContextSetLineCap(context, kCGLineCapSquare);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
    
    CGPathRelease(path);
    
    if (_shineEnabled) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        //Determine Size for Gloss
        CGRect glossRect = self.bounds;
        glossRect.size.width = calloutRect.size.width - _strokeWidth;
        glossRect.size.height = (calloutRect.size.height - _strokeWidth) / 2.0f;
        glossRect.origin.x = calloutRect.origin.x + _strokeWidth / 2.0f;
        glossRect.origin.y += calloutRect.origin.y + _strokeWidth / 2.0f;
        
        CGFloat glossTopRadius = _cornerRadius - _strokeWidth / 2.0f;
        CGFloat glossBottomRadius = _cornerRadius;
        
        //Create Path For Gloss
        CGMutablePathRef glossPath = CGPathCreateMutable();
        CGPathMoveToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossTopRadius);
        CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x, glossRect.origin.y + glossRect.size.height - glossBottomRadius);
        CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossBottomRadius, glossRect.origin.y + glossRect.size.height - glossBottomRadius, glossBottomRadius, M_PI, M_PI / 2.0f, clockwise);
        CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, glossRect.origin.y + glossRect.size.height);
        CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossBottomRadius, glossRect.origin.y + glossRect.size.height - glossBottomRadius, glossBottomRadius, M_PI / 2.0f, 0.0f, clockwise);
        CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossRect.size.width, glossRect.origin.y + glossTopRadius);
        CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossRect.size.width - glossTopRadius, glossRect.origin.y + glossTopRadius, glossTopRadius, 0.0f, -M_PI / 2.0f, clockwise);
        CGPathAddLineToPoint(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y);
        CGPathAddArc(glossPath, NULL, glossRect.origin.x + glossTopRadius, glossRect.origin.y + glossTopRadius, glossTopRadius, -M_PI / 2.0f, M_PI, clockwise);
        CGPathCloseSubpath(glossPath);
        
        //Fill Gloss Path
        CGContextAddPath(context, glossPath);
        CGContextClip(context);
        CGFloat colors[] =
        {
            1.0f, 1.0f, 1.0f, 0.3f,
            1.0f, 1.0f, 1.0f, 0.1f
        };
        CGFloat locations[] = { 0.0f, 1.0f };
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
        CGPoint startPoint = glossRect.origin;
        CGPoint endPoint = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        
        //Gradient Stroke Gloss Path
        CGContextAddPath(context, glossPath);
        CGContextSetLineWidth(context, 2);
        CGContextReplacePathWithStrokedPath(context);
        CGContextClip(context);
        CGFloat colors2[] =
        {
            1.0f, 1.0f, 1.0f, 0.3f,
            1.0f, 1.0f, 1.0f, 0.1f,
            1.0f, 1.0f, 1.0f, 0.0f
        };
        CGFloat locations2[] = { 0.0f, 0.1f, 1.0f };
        CGGradientRef gradient2 = CGGradientCreateWithColorComponents(colorSpace, colors2, locations2, 3);
        CGPoint startPoint2 = glossRect.origin;
        CGPoint endPoint2 = CGPointMake(glossRect.origin.x, glossRect.origin.y + glossRect.size.height);
        CGContextDrawLinearGradient(context, gradient2, startPoint2, endPoint2, 0);
        
        CGPathRelease(glossPath);
    	CGGradientRelease(gradient);
        CGGradientRelease(gradient2);
        CGColorSpaceRelease(colorSpace);
    }
}



#pragma mark -
#pragma mark Animation
- (void)animateCalloutAppearance {
    self.alpha = 1.0f;
	self.endFrame = self.frame;
	__block CGFloat scale = 0.001f;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
    
    [UIView animateWithDuration:0.075 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        scale = 1.1;
        self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGFloat scale = 0.95;
            self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                CGFloat scale = 1.0;
                self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
            } completion:nil];
        }];
    }];
}

- (void)animateCalloutDisappearance {
    [self setAlpha:1.0f];
    
    [UIView animateWithDuration:10.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setAlpha:0.0f];
    } completion:nil];
}



#pragma mark -
#pragma mark The helper methods
- (CGFloat)xTransformForScale:(CGFloat)scale {
	CGFloat xDistanceFromCenterToParent = self.endFrame.size.width / 2 - [self relativeParentXPosition];
	return (xDistanceFromCenterToParent * scale) - xDistanceFromCenterToParent;
}

- (CGFloat)yTransformForScale:(CGFloat)scale {
	CGFloat yDistanceFromCenterToParent = (((self.endFrame.size.height) / 2) + CalloutMapAnnotationViewBottomShadowBufferSize + CalloutMapAnnotationViewHeightAboveParent);
	return yDistanceFromCenterToParent - yDistanceFromCenterToParent * scale;
}

- (CGFloat)yShadowOffset {
	if (!_yShadowOffset) {
		float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (osVersion >= 3.2) {
			_yShadowOffset = 6;
		} else {
			_yShadowOffset = -6;
		}
		
	}
    
	return _yShadowOffset;
}

- (CGFloat)relativeParentXPosition {
	return self.bounds.size.width / 2;
}
@end