//
//  RegistoConfirmarEmailVC.m
//  Tapp
//
//  Created by Juancho Pestana on 2/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "RegistoConfirmarEmailVC.h"

@interface RegistoConfirmarEmailVC ()

@end

@implementation RegistoConfirmarEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // 1. CONFIGURAR SWIPE TRANSICION
    [self configurarSwipe];
    
    // 2. TRAER CORREO REGISTRADO Y PONERLO EN LABEL
    [self traerCorreoIngresado];

}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE

// METODO QUE CONFIGURAR SWIPE
- (void)configurarSwipe{
    
    _swipe_right.numberOfTouchesRequired = 2;
    _swipe_left.numberOfTouchesRequired = 2;
    
}// END CONFIGURAR SWIPE


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER CORREO INGRESADO Y PONERLO EN LABEL

- (void)traerCorreoIngresado{
    
    Registro *objeto_registro = [Registro registroGlobal];
    NSString *correo_registrado = [objeto_registro getCorreo];
    _label_correo_ingresado.text = correo_registrado;
//    NSLog(@"%@", correo_registrado);
    
}// END CORREO INGRESADO


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION SWIPE BACK
- (IBAction)accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"right" sender: self];
    
}// END SWIPE RIGHT

#pragma mark IPHONE
// ACCION SWIPE RIGHT
- (IBAction)iphone_accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END IPHONE ACCION SWIPE RIGHT


- (IBAction)iphone_accion_swipe_left:(id)sender {

    [self performSegueWithIdentifier: @"continuar" sender: self];

}// END IPHONE ACCION SWIPE LEFT


// ACCION SWIPE FORWARD
- (IBAction)accion_swipe_left:(id)sender {

    [self performSegueWithIdentifier: @"left" sender: self];

}// END ACCION SWIPE FORWARD




@end
