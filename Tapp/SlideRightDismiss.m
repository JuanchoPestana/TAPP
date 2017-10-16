//
//  SlideRightDismiss.m
//  Tapp
//
//  Created by Juan Pestana on 9/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "SlideRightDismiss.h"

@implementation SlideRightDismiss

- (void)perform{
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    
    [srcViewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
