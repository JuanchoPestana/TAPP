//
//  CrearVendedorViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 6/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"


@interface CrearVendedorViewController : UIViewController <UITextFieldDelegate>
// SWIPE OUTLETS
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_let;


// SWIPE ACCIONES
- (IBAction)accion_swipe_left:(id)sender;
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)iphone_accion_swipe_right:(id)sender;
- (IBAction)iphone_accion_swipe_left:(id)sender;




// TEXTFIELDS
@property (weak, nonatomic) IBOutlet UITextField *textfield_nombre;
@property (weak, nonatomic) IBOutlet UITextField *textfield_apellido;
@property (weak, nonatomic) IBOutlet UITextField *textfield_nomina;






@end
