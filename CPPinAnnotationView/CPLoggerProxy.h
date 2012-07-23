//
//  CPLoggerProxy.h
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 23.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CPLoggerProxy : NSObject {
    id original;
}

- (id)initWithOriginal:(id)value;
@end