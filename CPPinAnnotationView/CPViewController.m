//
//  CPViewController.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 17.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import "CPViewController.h"

#import "CPAnnotation.h"
#import "CPPinAnnotationView.h"



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
    CPAnnotation *annotation = [[CPAnnotation alloc] init];
    annotation.coordinate = userLocation.coordinate;
    annotation.title = @"You are here.";
    annotation.subtitle = [NSString stringWithFormat:@"Lat: %f, Long: %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    
    [_mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const kCPAnnotationIdentifer = @"MapViewAnnotation";
    
    MKAnnotationView *annotationView = nil;
    if ([annotation isMemberOfClass:[CPAnnotation class]]) {
        CPPinAnnotationView *pinAnnotationView = (CPPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:kCPAnnotationIdentifer];
        if (pinAnnotationView == nil) {
            pinAnnotationView = [[CPPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kCPAnnotationIdentifer];
            pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
            pinAnnotationView.animatesDrop = YES;
            pinAnnotationView.pinColor = CPPinAnnotationColorGreen;
            pinAnnotationView.canShowCallout = YES;
            pinAnnotationView.draggable = YES;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
            label.text = @"Hello, World!";
            pinAnnotationView.contentView = label;
            [label release];
            annotationView = pinAnnotationView;
        } else {
            annotationView.annotation = annotation;
        }
    }
    
    return annotationView;
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//
//}
//
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//}

@end
