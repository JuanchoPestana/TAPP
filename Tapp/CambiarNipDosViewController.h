//
//  CambiarNipDosViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Registro.h"
#import "ToastNip.h"

@interface CambiarNipDosViewController : UIViewController <UITextFieldDelegate>

// OUTLET SWIPE RIGHT
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;

// ACCION SWIPE RIGHT
- (IBAction)accion_swipe_right:(id)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;
- (IBAction)iphone_accion_swipe_right:(id)sender;



// VIEW TECLADO
@property (weak, nonatomic) IBOutlet UIView *teclado_cambiar_nip_dos;


// IMAGENES NIP
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_uno;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_dos;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_tres;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_cuatro;


// IMAGEN FONDO TECLADO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo_teclado;


// TEXTFIELD NIP
@property (weak, nonatomic) IBOutlet UITextField *textield_nip;

// OUTLETS BOTONES
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


// ACCION BOTONES
- (IBAction)accion_teclas:(id)sender;


// ACCIONES BOTONES HIGHLIGHT
- (IBAction)accion_touch_up:(id)sender;

- (IBAction)accion_touch_down:(id)sender;

@end
