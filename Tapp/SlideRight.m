//
//  SlideRight.m
//  Tapp
//
//  Created by Juancho Pestana on 2/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "SlideRight.h"

@implementation SlideRight

- (void)perform{
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
}



@end
