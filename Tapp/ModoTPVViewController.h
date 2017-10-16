//
//  ModoTPVViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 6/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaccion.h"

@interface ModoTPVViewController : UIViewController <UITextFieldDelegate>

// SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;

// ACCIONES SWIPE
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_swipe_left:(id)sender;



// TECLADO CUSTOM
@property (weak, nonatomic) IBOutlet UIView *teclado_custom_tpv;


// OUTLETS TECLAS
@property (weak, nonatomic) IBOutlet UIButton *tecla_1;
@property (weak, nonatomic) IBOutlet UIButton *tecla_2;
@property (weak, nonatomic) IBOutlet UIButton *tecla_3;
@property (weak, nonatomic) IBOutlet UIButton *tecla_4;
@property (weak, nonatomic) IBOutlet UIButton *tecla_5;
@property (weak, nonatomic) IBOutlet UIButton *tecla_6;
@property (weak, nonatomic) IBOutlet UIButton *tecla_7;
@property (weak, nonatomic) IBOutlet UIButton *tecla_8;
@property (weak, nonatomic) IBOutlet UIButton *tecla_9;
@property (weak, nonatomic) IBOutlet UIButton *tecla_0;
@property (weak, nonatomic) IBOutlet UIButton *tecla_back;

// IMAGEN FONDO TECLADO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo_teclado;

// ACCIONES UP TECLAS
- (IBAction)touch_up_teclas:(id)sender;


// ACCIONES DOWN TECLAS
- (IBAction)accion_down_teclas:(id)sender;


// ACCIONES TECLAS
- (IBAction)accion_teclas:(id)sender;


// TEXTFIELD
@property (weak, nonatomic) IBOutlet UITextField *textfield_tpv;

// LABEL
@property (weak, nonatomic) IBOutlet UILabel *label_cantidad;


@end
