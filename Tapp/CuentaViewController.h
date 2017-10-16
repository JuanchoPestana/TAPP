//
//  CuentaViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuentaViewController : UIViewController <UITextFieldDelegate>


// SWIPE OUTLET
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_left;


// SWIPE ACTION
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_swipe_left:(id)sender;
- (IBAction)iphone_accion_swipe_right:(id)sender;
- (IBAction)iphone_accion_swipe_left:(id)sender;

// TEXTFIELD NUMERO DE CUENTA
@property (weak, nonatomic) IBOutlet UITextField *textfield_numero_cuenta;



@end
