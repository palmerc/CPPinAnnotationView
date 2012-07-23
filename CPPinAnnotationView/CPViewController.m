//
//  CPViewController.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 17.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import "CPViewController.h"

#import "CPPinAnnotation.h"
#import "CPCalloutAnnotation.h"
#import "CPPinAnnotationView.h"
#import "CPCalloutAnnotationView.h"



@interface CPViewController ()
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
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const kCPPinAnnotationIdentifer = @"CPPinAnnotation";
    static NSString *const kCPCalloutAnnotationIdentifer = @"CPCalloutAnnotation";

    MKAnnotationView *annotationView = nil;
    if ([annotation isMemberOfClass:[CPPinAnnotation class]]) {
        CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kCPPinAnnotationIdentifer];
        if (pinAnnotationView == nil) {
            pinAnnotationView = [[CPPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kCPPinAnnotationIdentifer];
            pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
            pinAnnotationView.animatesDrop = YES;
            pinAnnotationView.pinColor = CPPinAnnotationColorGreen;
            pinAnnotationView.canShowCallout = YES;
            pinAnnotationView.draggable = YES;
        } else {
            pinAnnotationView.annotation = annotation;
        }
        
        annotationView = pinAnnotationView;
    } else if ([annotation isMemberOfClass:[CPCalloutAnnotation class]]) {
        CPCalloutAnnotationView *calloutAnnotationView = (CPCalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kCPCalloutAnnotationIdentifer];
        if (calloutAnnotationView == nil) {
            calloutAnnotationView = [[CPCalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kCPCalloutAnnotationIdentifer];
            calloutAnnotationView.bounds = CGRectMake(0.0f, 0.0f, 100.0f, 80.0f);
            calloutAnnotationView.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:0.25f];
        } else {
            calloutAnnotationView.annotation = annotation;
        }
        
        annotationView = calloutAnnotationView;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {       
    if ([view isMemberOfClass:[CPPinAnnotationView class]]) {
        CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *)view;
        
        CGPoint calloutOffset = pinAnnotationView.calloutOffset;
        CLLocationCoordinate2D coordinate = [mapView convertPoint:calloutOffset toCoordinateFromView:view];
        CPCalloutAnnotation *annotation = [[CPCalloutAnnotation alloc] initWithCoordinate:coordinate];
        pinAnnotationView.calloutAnnotation = annotation;
        
        [self.mapView addAnnotation:annotation];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view isMemberOfClass:[CPPinAnnotationView class]]) {
        CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *)view;
        CPCalloutAnnotation *annotation = pinAnnotationView.calloutAnnotation;
        if (annotation) {
            [self.mapView removeAnnotation:annotation];
            pinAnnotationView.calloutAnnotation = nil;
        }
    }
}

@end
