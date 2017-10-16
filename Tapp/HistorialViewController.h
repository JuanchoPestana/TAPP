//
//  HistorialViewController.h
//  Tapp
//
//  Created by Juan Pestana on 9/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistorialViewController : UIViewController

// SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
- (IBAction)accion_swipe_right:(id)sender;





@end
