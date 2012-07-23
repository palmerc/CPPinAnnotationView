//
//  CPLoggerProxy.m
//  CPPinAnnotationView
//
//  Created by Cameron Lowell Palmer on 23.07.12.
//  Copyright (c) 2012 Bird and Bear Industries. All rights reserved.
//

#import "CPLoggerProxy.h"



@implementation CPLoggerProxy

- (id) initWithOriginal:(id)value {
    if (self = [super init]) {
        original = value;
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *sig = [super methodSignatureForSelector:sel];
    if (sig == nil) {
        sig = [original methodSignatureForSelector:sel];
    }
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)inv {
    NSLog(@"[%@ %@] %@ %@", original, inv, [inv methodSignature], NSStringFromSelector([inv selector]));
    [inv invokeWithTarget:original];
}
@end
