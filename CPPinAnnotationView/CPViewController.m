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
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.canShowCallout = YES;
            annotationView.draggable = YES;
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if ([view isMemberOfClass:[MKPinAnnotationView class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)view;
        SEL selector = @selector(_highlightedImage);
        if ([annotationView respondsToSelector:selector]) {
//            NSArray *images = [annotationView performSelector:selector];
            
//            - (id)_pinBounceImages;
//            - (id)_highlightedImage;
            
//            int i = 0;
//            for (id image in images) {
            UIImage *image = [annotationView performSelector:selector];
//                UIImage *uiImage = [UIImage imageWithCGImage:image];
                
                NSData *png = UIImagePNGRepresentation(image);
                [png writeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:///Users/palmerc/red_pin_highlighted@2x.png"]] atomically:YES];
//                i++;
//            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

@end
