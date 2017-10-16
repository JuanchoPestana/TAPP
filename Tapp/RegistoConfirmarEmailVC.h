//
//  RegistoConfirmarEmailVC.h
//  Tapp
//
//  Created by Juancho Pestana on 2/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Registro.h"

@interface RegistoConfirmarEmailVC : UIViewController


// OUTLETS
@property (weak, nonatomic) IBOutlet UILabel *label_correo_ingresado;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_left;





// ACCIONES
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_swipe_left:(id)sender;
- (IBAction)iphone_accion_swipe_right:(id)sender;
- (IBAction)iphone_accion_swipe_left:(id)sender;


@end
