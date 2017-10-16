//
//  TicketViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 7/27/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketViewController : UIViewController

// SWIPE RIGHT 
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
- (IBAction)accion_swipe_right:(id)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
- (IBAction)accion_swipe_left:(id)sender;


// IMAGEN FONDO PRINCIPAL
@property (weak, nonatomic) IBOutlet UIImageView *fondo_principal;



// FONDO UNO
@property (weak, nonatomic) IBOutlet UIImageView *fondo_uno;

// FONDO DOS
@property (weak, nonatomic) IBOutlet UIImageView *fondo_dos;

// FONDO TRES
@property (weak, nonatomic) IBOutlet UIImageView *fondo_tres;


// LOGO
@property (weak, nonatomic) IBOutlet UIImageView *logo;


// TEXTOS
@property (weak, nonatomic) IBOutlet UILabel *nombre;
@property (weak, nonatomic) IBOutlet UILabel *monto;
@property (weak, nonatomic) IBOutlet UILabel *mxn;
@property (weak, nonatomic) IBOutlet UILabel *fecha;
@property (weak, nonatomic) IBOutlet UILabel *fecha_variable;
@property (weak, nonatomic) IBOutlet UILabel *tarjeta;
@property (weak, nonatomic) IBOutlet UILabel *asteriscos;
@property (weak, nonatomic) IBOutlet UILabel *numeros_tarjeta;

// ACCIONES
- (IBAction)accion_fondo_uno:(id)sender;
- (IBAction)accion_fondo_dos:(id)sender;
- (IBAction)accion_fondo_tres:(id)sender;
- (IBAction)accion_letras:(id)sender;

- (IBAction)accion_poner_color:(id)sender;


// TEXTFIELDS
@property (weak, nonatomic) IBOutlet UITextField *textfield_r;
@property (weak, nonatomic) IBOutlet UITextField *textfield_g;
@property (weak, nonatomic) IBOutlet UITextField *textfield_b;

// BOTON GMAIL


@end
