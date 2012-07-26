//
//  CPCalloutView.h
//  CPCalloutView
//
//  Created by Cameron Lowell Palmer on 18.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//



#import <UIKit/UIKit.h>



@interface CPCalloutView : UIView {
@private
	UIView *_contentView;
    
    CGPoint _anchorPoint;
    
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
    CGRect _endFrame;
    
    CGFloat _strokeWidth;
	CGFloat _cornerRadius;
    CGFloat _calloutWidthInset;
    CGFloat _calloutBottomInset;
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

@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat calloutWidthInset;
@property (nonatomic, assign) CGFloat calloutBottomInset;
@property (nonatomic, assign) CGFloat triangleWidth;
@property (nonatomic, assign) CGFloat triangleHeight;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, retain) UIColor *baseColor;
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign, getter=isShineEnabled) BOOL shineEnabled;

- (CGSize)sizeWithContentSize:(CGSize)contentViewRect;
@end
