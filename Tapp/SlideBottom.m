//
//  SlideBottom.m
//  Tapp
//
//  Created by Juancho Pestana on 3/4/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "SlideBottom.h"

@implementation SlideBottom

- (void)perform{
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
}

@end
