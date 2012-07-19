//
//  CPViewController.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 17.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import "CPViewController.h"

#import "CPAnnotation.h"



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
    
    MKPinAnnotationView *annotationView = nil;
    if ([annotation isMemberOfClass:[CPAnnotation class]]) {
        annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:kCPAnnotationIdentifer];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kCPAnnotationIdentifer];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
            annotationView.animatesDrop = YES;
            [annotationView setCanShowCallout:YES];
            
            SEL selector = @selector(_image);
            if ([annotationView respondsToSelector:selector]) {
                id image = [annotationView respondsToSelector:selector];
                NSLog(@"");
            }
        }
    }
    
    return annotationView;
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//
//}

@end
