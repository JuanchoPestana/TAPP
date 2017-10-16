//
//  CrearNipUnoVC.h
//  Tapp
//
//  Created by Juancho Pestana on 2/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Registro.h"

@interface CrearNipUnoVC : UIViewController <UITextFieldDelegate>

// OUTLETS
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;


@property (weak, nonatomic) IBOutlet UITextField *textfield_nip;

// TECLADO OUTLETS
@property (weak, nonatomic) IBOutlet UIView *teclado_custom_crear_nip;
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

// OUTLETS IMAGENES NIP
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_uno;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_dos;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_tres;
@property (weak, nonatomic) IBOutlet UIImageView *imagen_nip_cuatro;

// IMAGEN FONDO TECLADO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo_teclado;



// ACCION TECLAS
- (IBAction)accion_teclas:(id)sender;


// ACCIONES
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)iphone_accion_swipe_right:(id)sender;


// ACCIONES HIGHLIGHT TECLAS
- (IBAction)accion_teclas_down:(id)sender;

- (IBAction)accion_teclas_up:(id)sender;


@end
