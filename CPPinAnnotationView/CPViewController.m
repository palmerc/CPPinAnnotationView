//
//  CPViewController.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 17.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import "CPViewController.h"

#import "CPPinAnnotation.h"
#import "CPPinAnnotationView.h"
#import "CPCalloutView.h"
#import "CPLoggerProxy.h"



@interface CPViewController ()
- (UIView *)mapView:(MKMapView *)mapView calloutViewForAnnotationView:(MKAnnotationView *)view withContentView:(UIView *)contentView;
@end



@implementation CPViewController
@synthesize mapView = _mapView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mapView setShowsUserLocation:YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark -
#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CPPinAnnotation *annotation = [[CPPinAnnotation alloc] init];
    annotation.coordinate = userLocation.coordinate;
    annotation.title = @"You are here.";
    annotation.subtitle = [NSString stringWithFormat:@"Lat: %f, Long: %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    
    [_mapView addAnnotation:annotation];
    [annotation release];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const kCPPinAnnotationIdentifer = @"CPPinAnnotation";
    
    MKAnnotationView *annotationView = nil;
    if ([annotation isMemberOfClass:[CPPinAnnotation class]]) {
        CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kCPPinAnnotationIdentifer];
        if (pinAnnotationView == nil) {
            
            pinAnnotationView = [[[CPPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kCPPinAnnotationIdentifer] autorelease];
            pinAnnotationView.pinColor = CPPinAnnotationColorGreen;
            pinAnnotationView.draggable = YES;
        } else {
            pinAnnotationView.annotation = annotation;
        }
        
        annotationView = pinAnnotationView;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view isMemberOfClass:[CPPinAnnotationView class]]) {
        CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *)view;

        UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
        NSString *hello = @"Current Location";
        CGSize size = [hello sizeWithFont:font];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4.0f, 4.0f, size.width, size.height)];
        label.text = hello;
        label.font = font;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width + 8.0f, size.height + 8.0f)];
        [contentView addSubview:label];
        [label release];

        pinAnnotationView.calloutView = [self mapView:mapView calloutViewForAnnotationView:view withContentView:contentView];
        [contentView release];
    }
}

- (UIView *)mapView:(MKMapView *)mapView calloutViewForAnnotationView:(MKAnnotationView *)view withContentView:(UIView *)contentView {
    CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *)view;
    
    // Lat/Long above pin head
    CLLocationCoordinate2D coordinate = [mapView convertPoint:pinAnnotationView.calloutOffset toCoordinateFromView:pinAnnotationView];
     // The spot above the pin head
    CGPoint mapViewAnchorPoint = [mapView convertCoordinate:coordinate toPointToView:mapView];
    
    CPCalloutView *calloutView = [[CPCalloutView alloc] initWithFrame:CGRectZero];
    calloutView.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f];
    calloutView.contentView = contentView;
    
    // Get the size of the callout with a given bit of content
    CGSize calloutSize = [calloutView sizeWithContentSize:contentView.bounds.size];
    
    // Starting from the anchor point move the y origin up the height of the pin annotation view.
    CGRect calloutFrame = CGRectMake(mapViewAnchorPoint.x, mapViewAnchorPoint.y, calloutSize.width, calloutSize.height);
    calloutFrame.origin.y -= pinAnnotationView.bounds.size.height;
    
    // Convert the callout frames coordinates from the mapView to inside the pin view
    CGRect pinViewCalloutFrame = [mapView convertRect:calloutFrame toView:pinAnnotationView];
    calloutView.frame = pinViewCalloutFrame;
    
    // Convert the mapView's anchorPoint to the pinView's coordinate system
    CGPoint pinViewAnchorPoint = [mapView convertPoint:mapViewAnchorPoint toView:pinAnnotationView];
    // Convert the mapView's center to the pinView's coordinate system
    CGPoint pinViewMapViewCenter = [mapView convertPoint:mapView.center toView:pinAnnotationView];
    // This doesn't make sense.
    CGPoint pinViewCalloutViewCenter = calloutView.center;
    
    if (pinViewCalloutViewCenter.x < pinViewMapViewCenter.x) { // LHS
        CGFloat maxDistance = 0.0f;
        CGFloat centerDistance = pinViewMapViewCenter.x - pinViewCalloutViewCenter.x;
        pinViewCalloutViewCenter.x += MIN(centerDistance, maxDistance);
        calloutView.center = pinViewCalloutViewCenter;
    } else if (pinViewCalloutViewCenter.x > pinViewMapViewCenter.x) { //RHS
        CGFloat maxDistance = calloutView.bounds.size.width - pinViewAnchorPoint.x;
        CGFloat centerDistance = pinViewCalloutViewCenter.x - pinViewMapViewCenter.x;
        pinViewCalloutViewCenter.x -= MIN(centerDistance, maxDistance);
        calloutView.center = pinViewCalloutViewCenter;
    }
    
    if (calloutSize.width < mapView.bounds.size.width) {
        // shift on screen
    }

    return [calloutView autorelease];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view isMemberOfClass:[CPPinAnnotationView class]]) {
        CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *)view;
        
        pinAnnotationView.calloutView = nil;
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *view in views) {
        if ([view isMemberOfClass:[CPPinAnnotationView class]]) {
            CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *)view;
            
            MKMapPoint point =  MKMapPointForCoordinate(pinAnnotationView.annotation.coordinate);
            if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
                continue;
            }
            
            CGRect endFrame = pinAnnotationView.frame;
            // Move annotation out of view
            pinAnnotationView.frame = CGRectMake(pinAnnotationView.frame.origin.x, pinAnnotationView.frame.origin.y - self.view.frame.size.height, pinAnnotationView.frame.size.width, pinAnnotationView.frame.size.height);
            
            [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationCurveEaseIn animations:^{
                pinAnnotationView.frame = endFrame;
            } completion:^(BOOL finished){
            }];
        }
    }
}
@end
