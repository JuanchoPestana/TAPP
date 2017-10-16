//
//  RegistroEmailVC.h
//  Tapp
//
//  Created by Juancho Pestana on 2/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Registro.h"

@interface RegistroEmailVC : UIViewController <UITextFieldDelegate>


// OUTLETS
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_left;

// EMAIL
@property (weak, nonatomic) IBOutlet UITextField *textfield_email_registro;

// ACCIONES
- (IBAction)accion_swipe_left:(id)sender;
- (IBAction)iphone_accion_swipe_left:(id)sender;



@end
