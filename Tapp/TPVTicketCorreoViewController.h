//
//  TPVTicketCorreoViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 8/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaccion.h"
#import "Reachibility.h"


@interface TPVTicketCorreoViewController : UIViewController <UITextFieldDelegate>

// SWIPE OUTLETS
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;

// ACCION SWIPE
- (IBAction)accion_swipe_left:(id)sender;
- (IBAction)accion_swipe_right:(id)sender;

// TEXTFIELD
@property (weak, nonatomic) IBOutlet UITextField *textfield_correo;

// BOTONES CORREOS SHORTCUTS

- (IBAction)accion_gmail:(id)sender;
- (IBAction)accion_hotmail:(id)sender;
- (IBAction)accion_icloud:(id)sender;
- (IBAction)accion_outlook:(id)sender;
- (IBAction)accion_yahoo:(id)sender;
- (IBAction)accion_com:(id)sender;
- (IBAction)accion_com_mx:(id)sender;



@end
