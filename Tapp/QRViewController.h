//
//  QRViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/26/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface QRViewController : UIViewController

// OUTLET SWIPE RIGHT
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;


// ACCION SWIPE RIGHT
- (IBAction)accion_swipe_right:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
