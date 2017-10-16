//
//  CambiarNipUnoViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Registro.h"


@interface CambiarNipUnoViewController : UIViewController <UITextFieldDelegate>

// OUTLET SWIPE RIGHT
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;



// ACCION SWIPE RIGHT
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)iphone_accion_swipe_right:(id)sender;


// VIEW TECLADO
@property (weak, nonatomic) IBOutlet UIView *teclado_cambiar_nip_uno;


// OUTLETS IMAGENES
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_uno;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_dos;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_tres;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_cuatro;


// OUTLET TEXTFIELD
@property (weak, nonatomic) IBOutlet UITextField *textield_nip;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo_teclado;


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


// ACCIONES HIGHLIGHT TECLAS
- (IBAction)accion_touch_down:(id)sender;

- (IBAction)accion_touch_up:(id)sender;



@end
