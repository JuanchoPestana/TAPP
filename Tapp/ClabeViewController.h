//
//  ClabeViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClabeViewController : UIViewController <UITextFieldDelegate>


// SWIPE OUTLETS
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_left;


// ACCIONES SWIPES
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_swipe_left:(id)sender;
- (IBAction)iphone_accion_swipe_right:(id)sender;
- (IBAction)iphone_accion_swipe_left:(id)sender;


// TEXTFIELD CLABE
@property (weak, nonatomic) IBOutlet UITextField *textfield_clabe;


@end
