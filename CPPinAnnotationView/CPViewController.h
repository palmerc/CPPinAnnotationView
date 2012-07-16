//
//  CPViewController.h
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 17.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>



@interface CPViewController : UIViewController <MKMapViewDelegate> {
@private
    MKMapView *_mapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@end
