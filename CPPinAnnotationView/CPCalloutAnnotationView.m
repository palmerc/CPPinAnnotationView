//
//  CPPinCalloutView.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//



#import "CPCalloutAnnotationView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark -
#pragma mark Constants



#pragma mark -
#pragma mark Private Property
@interface CPCalloutAnnotationView ()
@property (nonatomic, readonly) CGFloat yShadowOffset;
@property (nonatomic) CGRect endFrame;
@end



#pragma mark -
#pragma mark Implementation
@implementation CPCalloutAnnotationView
@synthesize contentView = _contentView;
@synthesize anchorPoint = _anchorPoint;
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



- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        _strokeWidth = 1.0f;
        _cornerRadius = 8.0f;
        _calloutInset = 0.0f;
        _triangleWidth = 30.0f;
        _triangleHeight = 15.0f;
        _shadowOffset = CGSizeMake(0.0f, 6.0f);
        _shadowBlur = 6.0f;
        
        _shineEnabled = YES;
        
		self.backgroundColor = [UIColor clearColor];
        self.baseColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        self.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.borderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.9f];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = _cornerRadius;
	}
    
	return self;
}

- (void)dealloc {
    [_baseColor release];
    [_shadowColor release];
    [_borderColor release];
    
	[_contentView release];
    
    [super dealloc];
}

- (BOOL)canShowCallout {
    return NO; // Prevent the stock view from appearing
}



#pragma mark -
#pragma mark drawRect
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
#pragma mark Setter
- (void)setContentView:(UIView *)contentView {
    if (contentView != _contentView) {
        [_contentView removeFromSuperview];
        [_contentView release];
        _contentView = nil;
        
        _contentView = [contentView retain];
        [self addSubview:_contentView];
    }
}



#pragma mark -
#pragma mark Animation
- (void)animateCalloutAppearance {
    self.endFrame = self.frame;
    CGFloat scale = 0.001f;
	self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        CGFloat scale = 1.3f;
        self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGFloat scale = 0.95;
            self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                CGFloat scale = 1.0;
                self.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, [self xTransformForScale:scale], [self yTransformForScale:scale]);
            } completion:nil];
        }];
    }];
}



#pragma mark -
#pragma mark The animation helper methods
- (CGFloat)relativeParentXPosition {
	return self.bounds.size.width / 2.0f;
}

- (CGFloat)xTransformForScale:(CGFloat)scale {
	CGFloat xDistanceFromCenterToParent = self.endFrame.size.width / 2.0f - [self relativeParentXPosition];
	CGFloat transformX = (xDistanceFromCenterToParent * scale) - xDistanceFromCenterToParent;
    
    return transformX;
}

- (CGFloat)yTransformForScale:(CGFloat)scale {
	CGFloat yDistanceFromCenterToParent = self.endFrame.size.height / 2.0f;
	CGFloat transformY = yDistanceFromCenterToParent - yDistanceFromCenterToParent * scale;    

    return transformY;
}
@end