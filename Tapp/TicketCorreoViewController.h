//
//  TicketCorreoViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Transaccion.h"
#import "Reachibility.h"



@interface TicketCorreoViewController : UIViewController <UITextFieldDelegate>

// OUTLETS SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;


// ACCIONES SWIPE
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_swipe_left:(id)sender;


// TEXTFIELD CORREO
@property (weak, nonatomic) IBOutlet UITextField *textfield_correo;



// BOTONES MAILS
- (IBAction)accion_gmail:(id)sender;
- (IBAction)accion_hotmail:(id)sender;
- (IBAction)accion_icloud:(id)sender;
- (IBAction)accion_outlook:(id)sender;
- (IBAction)accion_yahoo:(id)sender;
- (IBAction)accion_com:(id)sender;
- (IBAction)accion_commx:(id)sender;

@end
