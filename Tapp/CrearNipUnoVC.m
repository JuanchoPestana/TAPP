//
//  CrearNipUnoVC.m
//  Tapp
//
//  Created by Juancho Pestana on 2/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "CrearNipUnoVC.h"

@interface CrearNipUnoVC ()

@end

@implementation CrearNipUnoVC
@synthesize teclado_custom_crear_nip;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. CONFIGURAR TEXTFIELD
    [self configurarTextfield];
    

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
    
}// END CONFIGURAR SWIPE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE PONE IMAGENES ON/OFF DEL NIP

- (void)imagenesNip{
    
    
    if (_textfield_nip.text.length == 0) {
        _imagen_nip_uno.image = [UIImage imageNamed:@"nipOffNegro.png"];
        _imagen_nip_dos.image = [UIImage imageNamed:@"nipOffNegro.png"];
        _imagen_nip_tres.image = [UIImage imageNamed:@"nipOffNegro.png"];
        _imagen_nip_cuatro.image = [UIImage imageNamed:@"nipOffNegro.png"];
        
        _tecla_1.enabled = YES;
        _tecla_2.enabled = YES;
        _tecla_3.enabled = YES;
        _tecla_4.enabled = YES;
        _tecla_5.enabled = YES;
        _tecla_6.enabled = YES;
        _tecla_7.enabled = YES;
        _tecla_8.enabled = YES;
        _tecla_9.enabled = YES;
        _tecla_0.enabled = YES;
    }
    if (_textfield_nip.text.length == 1) {
        _imagen_nip_uno.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_dos.image = [UIImage imageNamed:@"nipOffNegro.png"];
        _imagen_nip_tres.image = [UIImage imageNamed:@"nipOffNegro.png"];
        _imagen_nip_cuatro.image = [UIImage imageNamed:@"nipOffNegro.png"];
       
        
        _tecla_1.enabled = YES;
        _tecla_2.enabled = YES;
        _tecla_3.enabled = YES;
        _tecla_4.enabled = YES;
        _tecla_5.enabled = YES;
        _tecla_6.enabled = YES;
        _tecla_7.enabled = YES;
        _tecla_8.enabled = YES;
        _tecla_9.enabled = YES;
        _tecla_0.enabled = YES;
    }
    if (_textfield_nip.text.length == 2) {
        _imagen_nip_uno.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_dos.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_tres.image = [UIImage imageNamed:@"nipOffNegro.png"];
        _imagen_nip_cuatro.image = [UIImage imageNamed:@"nipOffNegro.png"];
      
        
        _tecla_1.enabled = YES;
        _tecla_2.enabled = YES;
        _tecla_3.enabled = YES;
        _tecla_4.enabled = YES;
        _tecla_5.enabled = YES;
        _tecla_6.enabled = YES;
        _tecla_7.enabled = YES;
        _tecla_8.enabled = YES;
        _tecla_9.enabled = YES;
        _tecla_0.enabled = YES;
    }
    if (_textfield_nip.text.length == 3) {
        _imagen_nip_uno.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_dos.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_tres.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_cuatro.image = [UIImage imageNamed:@"nipOffNegro.png"];
     
        
        _tecla_1.enabled = YES;
        _tecla_2.enabled = YES;
        _tecla_3.enabled = YES;
        _tecla_4.enabled = YES;
        _tecla_5.enabled = YES;
        _tecla_6.enabled = YES;
        _tecla_7.enabled = YES;
        _tecla_8.enabled = YES;
        _tecla_9.enabled = YES;
        _tecla_0.enabled = YES;
    }
    if (_textfield_nip.text.length == 4) {
        _imagen_nip_uno.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_dos.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_tres.image = [UIImage imageNamed:@"nipOnNegro.png"];
        _imagen_nip_cuatro.image = [UIImage imageNamed:@"nipOnNegro.png"];
       
        
        _tecla_1.enabled = NO;
        _tecla_2.enabled = NO;
        _tecla_3.enabled = NO;
        _tecla_4.enabled = NO;
        _tecla_5.enabled = NO;
        _tecla_6.enabled = NO;
        _tecla_7.enabled = NO;
        _tecla_8.enabled = NO;
        _tecla_9.enabled = NO;
        _tecla_0.enabled = NO;
        
    }
    
}// END IMAGENES NIP


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE CONFIGURAR EL TEXTFIELD PARA EL NIP

- (void)configurarTextfield{
    
    _textfield_nip.delegate = self;
    _textfield_nip.hidden = YES;
    
}// END CONFIGURAR TEXTFIELD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION SWIPE BACKWARD

- (IBAction)accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"right" sender: self];

}// END ACCION SWIPE BACKWARD

// ACCION IPHONE SWIPE RIGHT
- (IBAction)iphone_accion_swipe_right:(id)sender {

    [self performSegueWithIdentifier: @"right" sender: self];

}// END ACCION IPHONE SWIPE RIGHT



///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// CONTINUAR SIN BOTON

- (void)continuarSinBoton{
    
    
    NSString *nipTecleado = self.textfield_nip.text;
    
    if (nipTecleado.length == 4) {
        
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(moverASiguientePantalla) userInfo:nil repeats:NO];
    }
    
}// END CONTINUAR SIN BOTON

// METODO QUE PRESENTA SIGUIENTE VIEW CONTROLLER
- (void)moverASiguientePantalla{
    
    Registro *objeto_registro = [Registro registroGlobal];
    [objeto_registro setNip:_textfield_nip.text];
    
    [self performSegueWithIdentifier: @"left" sender: self];
    
}// END MOVER SIGUIENTE PANTALLA

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// BLOQUEAR APARICION DEL TECLADO

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION TECLAS
- (IBAction)accion_teclas:(id)sender {
    
    UIButton *tmp = (UIButton*)sender;
    UITextField *inputTo = _textfield_nip;
    int wat = (int)tmp.tag;
    switch (wat) {
        case 1:
            inputTo.text = [NSString stringWithFormat:@"%@1", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 2:
            inputTo.text = [NSString stringWithFormat:@"%@2", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 3:
            inputTo.text = [NSString stringWithFormat:@"%@3", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 4:
            inputTo.text = [NSString stringWithFormat:@"%@4", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 5:
            inputTo.text = [NSString stringWithFormat:@"%@5", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 6:
            inputTo.text = [NSString stringWithFormat:@"%@6", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 7:
            inputTo.text = [NSString stringWithFormat:@"%@7", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 8:
            inputTo.text = [NSString stringWithFormat:@"%@8", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 9:
            inputTo.text = [NSString stringWithFormat:@"%@9", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
        case 0:
            inputTo.text = [NSString stringWithFormat:@"%@0", inputTo.text];
            [self imagenesNip];
            [self continuarSinBoton];
            break;
            
        case 10: {
            if ([inputTo.text length]>0) {
                NSString *newString = [inputTo.text substringToIndex:[inputTo.text length]-1];
                inputTo.text = newString;
                [self imagenesNip];
            }
        }
            break;
    }// END SWITCH

    
}// END ACCION TECLAS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODOS PARA CAMBIAR HIGHTLITH DE CADA TECLA

- (IBAction)accion_teclas_down:(id)sender {
    
    UIButton *tmp = (UIButton*)sender;
    int wat = (int)tmp.tag;
    switch (wat) {
            
        case 1:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T1.png"];
            break;
        case 2:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T2.png"];
            break;
        case 3:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T3.png"];
            break;
        case 4:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T4.png"];
            break;
        case 5:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T5.png"];
            break;
        case 6:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T6.png"];
            break;
        case 7:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T7.png"];
            break;
        case 8:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T8.png"];
            break;
        case 9:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T9.png"];
            break;
        case 0:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T0.png"];
            break;
        case 10:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"T<.png"];
            break;
    }

}// END ACCION TOCUH DOWN


// METODO QUE PONE TECLADO NORMAL CUANDO SUELTAS LA TECLA
- (IBAction)accion_teclas_up:(id)sender {

    UIButton *tmp = (UIButton*)sender;
    int wat = (int)tmp.tag;
    switch (wat) {
            
        case 1:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 2:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 3:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 4:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 5:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 6:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 7:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 8:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 9:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 0:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
        case 10:
            _imagen_fondo_teclado.image = [UIImage imageNamed:@"TBASE.png"];
            break;
    }

}// END ACCION TOUCH UP





@end
