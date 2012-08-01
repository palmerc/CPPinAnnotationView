    //
//  CPCalloutView.m
//  CPCalloutView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//



#import "CPCalloutView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>



#pragma mark -
#pragma mark Constants



#pragma mark -
#pragma mark Private Property
@interface CPCalloutView ()
@property (nonatomic, readonly) CGFloat yShadowOffset;
@property (nonatomic) CGRect endFrame;
@end



#pragma mark -
#pragma mark Implementation
@implementation CPCalloutView
@synthesize contentView = _contentView;
@synthesize anchorPoint = _anchorPoint;
@synthesize endFrame = _endFrame;
@synthesize yShadowOffset = _yShadowOffset;
@synthesize strokeWidth = _strokeWidth;
@synthesize cornerRadius = _cornerRadius;
@synthesize calloutWidthInset = _calloutWidthInset;
@synthesize calloutBottomInset = _calloutBottomInset;
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
    
    if (self != nil) {
        _strokeWidth = 1.0f;
        _cornerRadius = 8.0f;
     
        // For the shadow
        _calloutWidthInset = 2.0f;
        _calloutBottomInset = 4.0f;
        _shadowOffset = CGSizeMake(0.0f, _calloutBottomInset);
        _shadowBlur = 4.0f;
        
        _triangleWidth = 30.0f;
        _triangleHeight = 15.0f;
                
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



#pragma mark -
#pragma mark UIView methods
- (void)layoutSubviews {
    CGRect frame = self.contentView.frame;
    frame.origin.x = _strokeWidth + _calloutWidthInset;
    frame.origin.y = _strokeWidth;
    
    self.contentView.frame = frame;
}

- (void)drawRect:(CGRect)rect {
    CGRect calloutRect = rect;
    	
	//Determine Size
	calloutRect = self.bounds;
	calloutRect.size.width -= 2.0f * (_strokeWidth + _calloutWidthInset);
	calloutRect.size.height -= 2.0f * _strokeWidth + _triangleHeight + _calloutBottomInset;
	calloutRect.origin.x += _strokeWidth + _calloutWidthInset;
	calloutRect.origin.y += _strokeWidth;
    
    CGRect insetRect = CGRectInset(calloutRect, _cornerRadius, _cornerRadius);
    CGPoint topSideLeft = CGPointMake(insetRect.origin.x, calloutRect.origin.y);
    CGPoint topSideRight = CGPointMake(insetRect.origin.x + insetRect.size.width, calloutRect.origin.y);
    
    CGPoint rightSideTop = CGPointMake(calloutRect.origin.x + calloutRect.size.width, insetRect.origin.y);
    CGPoint rightSideBottom = CGPointMake(calloutRect.origin.x + calloutRect.size.width, insetRect.origin.y + insetRect.size.height);
    
    CGPoint bottomSideRight = CGPointMake(insetRect.origin.x + insetRect.size.width, calloutRect.origin.y + calloutRect.size.height);
    CGPoint bottomSideLeft = CGPointMake(insetRect.origin.x, calloutRect.origin.y + calloutRect.size.height);
    
    CGPoint leftSideBottom = CGPointMake(calloutRect.origin.x, insetRect.origin.y + insetRect.size.height);
    CGPoint leftSideTop = CGPointMake(calloutRect.origin.x, insetRect.origin.y);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
	CGPathMoveToPoint(path, NULL, topSideLeft.x, topSideLeft.y);
	CGPathAddLineToPoint(path, NULL, topSideRight.x, topSideRight.y);
	CGPathAddArcToPoint(path, NULL, rightSideTop.x, topSideRight.y, rightSideTop.x, rightSideTop.y, _cornerRadius);
	CGPathAddLineToPoint(path, NULL, rightSideBottom.x, rightSideBottom.y);
	CGPathAddArcToPoint(path, NULL, rightSideBottom.x, bottomSideRight.y, bottomSideRight.x, bottomSideRight.y, _cornerRadius);
    
    // The callout triangle below the box
	CGPathAddLineToPoint(path, NULL, _anchorPoint.x + floorf(_triangleWidth / 2.0f), bottomSideRight.y);
	CGPathAddLineToPoint(path, NULL, _anchorPoint.x, calloutRect.origin.y + calloutRect.size.height + _triangleHeight);
    CGPathAddLineToPoint(path, NULL, _anchorPoint.x - floorf(_triangleWidth / 2.0f), bottomSideRight.y);
    
	CGPathAddLineToPoint(path, NULL, bottomSideLeft.x, bottomSideLeft.y);
	CGPathAddArcToPoint(path, NULL, leftSideBottom.x, bottomSideLeft.y, leftSideBottom.x, leftSideBottom.y, _cornerRadius);
	CGPathAddLineToPoint(path, NULL, leftSideTop.x, leftSideTop.y);
	CGPathAddArcToPoint(path, NULL, leftSideTop.x, topSideLeft.y, topSideLeft.x, topSideLeft.y, _cornerRadius);
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
        CGRect glossRect = CGRectZero;
        glossRect.origin.x = calloutRect.origin.x + _strokeWidth;
        glossRect.origin.y = calloutRect.origin.y + _strokeWidth;
        glossRect.size.width = calloutRect.size.width - 2.0f * _strokeWidth;
        glossRect.size.height = floorf((calloutRect.size.height - 2.0f * _strokeWidth) / 2.0f);
        
        CGFloat glossRadius = _cornerRadius - _strokeWidth;
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:glossRect cornerRadius:glossRadius];
        CGPathRef glossPath = [bezierPath CGPath];
        
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

- (CGSize)sizeWithContentSize:(CGSize)contentSize {
    contentSize.width += 2.0f * (_strokeWidth + _calloutWidthInset);
	contentSize.height += 2.0f * _strokeWidth + _triangleHeight + _calloutBottomInset;
    
    return contentSize;
}
@end