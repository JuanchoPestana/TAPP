//
//  ModoTPVViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 6/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "ModoTPVViewController.h"

@interface ModoTPVViewController ()

@end


int contador_tpv;
int arreglo_tpv[20];
int cero_tpv;
int uno_tpv;
int dos_tpv;
int tres_tpv;
int cuatro_tpv;
int cinco_tpv;
int seis_tpv;
int siete_tpv;
int ocho_tpv;

NSString *monto_temporal;

@implementation ModoTPVViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. SWIPE
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
    _swipe_left.numberOfTouchesRequired = 2;
    
    
}// END CONFIGURAR SWIPE


- (IBAction)accion_swipe_right:(id)sender {
    
    double monto_final = 0.0;
    NSString *string_monto = [NSString stringWithFormat:@"%0.2f", monto_final];
    
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
    [objeto_transaccion set_monto_transaccion:string_monto];
    [objeto_transaccion set_tipo_pago_transaccion:@"tarjeta"];
    _textfield_tpv.text = @"";
    _label_cantidad.text = @"00.00";
    contador_tpv = 0;

    
    [self performSegueWithIdentifier: @"regresar" sender: self];
    
}// END ACCION SWIPE RIGHT

- (IBAction)accion_swipe_left:(id)sender {
    
    [self ponerMontoEnTransaccionGlobalYAVANZAR];
}
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE CONFIGURAR EL TEXTFIELD PARA EL NIP

- (void)configurarTextfield{
    
    _textfield_tpv.delegate = self;
    _textfield_tpv.hidden = YES;
    _label_cantidad.text = @"00.00";
    
}// END CONFIGURAR TEXTFIELD

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
// TOUCH UP TECLAS
- (IBAction)touch_up_teclas:(id)sender {
   
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

    
}// END TOUCH UP

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TOUCH DOWN TECLAS
- (IBAction)accion_down_teclas:(id)sender {
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

    
}// END TOUCH DOWN

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCIO TECLAS
- (IBAction)accion_teclas:(id)sender {
    
    UIButton *tmp = (UIButton*)sender;
    UITextField *inputTo = _textfield_tpv;
    int wat = (int)tmp.tag;
    switch (wat) {
        case 1:
            inputTo.text = [NSString stringWithFormat:@"%@1", inputTo.text];
            [self inputDigitos:1];
            break;
        case 2:
            inputTo.text = [NSString stringWithFormat:@"%@2", inputTo.text];
            [self inputDigitos:2];
            break;
        case 3:
            inputTo.text = [NSString stringWithFormat:@"%@3", inputTo.text];
            [self inputDigitos:3];
            break;
        case 4:
            inputTo.text = [NSString stringWithFormat:@"%@4", inputTo.text];
            [self inputDigitos:4];
            break;
        case 5:
            inputTo.text = [NSString stringWithFormat:@"%@5", inputTo.text];
            [self inputDigitos:5];
            break;
        case 6:
            inputTo.text = [NSString stringWithFormat:@"%@6", inputTo.text];
            [self inputDigitos:6];
            break;
        case 7:
            inputTo.text = [NSString stringWithFormat:@"%@7", inputTo.text];
            [self inputDigitos:7];
            break;
        case 8:
            inputTo.text = [NSString stringWithFormat:@"%@8", inputTo.text];
            [self inputDigitos:8];
            break;
        case 9:
            inputTo.text = [NSString stringWithFormat:@"%@9", inputTo.text];
            [self inputDigitos:9];
            break;
        case 0:
            inputTo.text = [NSString stringWithFormat:@"%@0", inputTo.text];
            [self inputDigitos:0];
            break;
            
        case 10: {
            if ([inputTo.text length]>0) {
                NSString *newString = [inputTo.text substringToIndex:[inputTo.text length]-1];
                inputTo.text = newString;
                 [self borrarDigitos];
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
//
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE INPUTEA DIGITOS COMO TERMINAL
- (void)inputDigitos: (int)digito{
    
    NSString *resul;
    
    switch (contador_tpv) {
        case 0:
            
            resul = [NSString stringWithFormat:@"00.0%d", digito];
            cero_tpv = digito;
            break;
        case 1:
            resul = [NSString stringWithFormat:@"00.%d%d", cero_tpv, digito];
            uno_tpv = digito;
            
            break;
        case 2:
            resul = [NSString stringWithFormat:@"0%d.%d%d", cero_tpv, uno_tpv, digito];
            dos_tpv = digito;
            break;
        case 3:
            resul = [NSString stringWithFormat:@"%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, digito];
            tres_tpv = digito;
            break;
        case 4:
            resul = [NSString stringWithFormat:@"%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, digito];
            cuatro_tpv = digito;
            break;
        case 5:
            resul = [NSString stringWithFormat:@"%d,%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, cuatro_tpv, digito];
            cinco_tpv = digito;
            break;
        case 6:
            resul = [NSString stringWithFormat:@"%d%d,%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, cuatro_tpv, cinco_tpv, digito];
            seis_tpv = digito;
            break;
        case 7:
            resul = [NSString stringWithFormat:@"%d%d%d,%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, cuatro_tpv, cinco_tpv, seis_tpv, digito];
            siete_tpv = digito;
            
            break;
        case 8:
            resul = [NSString stringWithFormat:@"%d,%d%d%d,%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, cuatro_tpv, cinco_tpv, seis_tpv, siete_tpv, digito];
            ocho_tpv = digito;
            _tecla_0.enabled = NO;
            _tecla_1.enabled = NO;
            _tecla_2.enabled = NO;
            _tecla_3.enabled = NO;
            _tecla_4.enabled = NO;
            _tecla_5.enabled = NO;
            _tecla_6.enabled = NO;
            _tecla_7.enabled = NO;
            _tecla_8.enabled = NO;
            _tecla_9.enabled = NO;
            break;
            
            
            
    }
    
    [_label_cantidad setText:resul];
    
    contador_tpv++;
    
}// END INPUT DIGITOS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PARA BORRAR LOS DIGITOS
- (void)borrarDigitos{
    
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
    
    NSString *resul;
    
    switch (contador_tpv) {
        case 9:
            resul = [NSString stringWithFormat:@"%d%d%d,%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, cuatro_tpv, cinco_tpv, seis_tpv, siete_tpv];
            break;
        case 8:
            resul = [NSString stringWithFormat:@"%d%d,%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, cuatro_tpv, cinco_tpv, seis_tpv];
            break;
        case 7:
            resul = [NSString stringWithFormat:@"%d,%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, cuatro_tpv, cinco_tpv];
            break;
        case 6:
            resul = [NSString stringWithFormat:@"%d%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv, cuatro_tpv];
            break;
        case 5:
            resul = [NSString stringWithFormat:@"%d%d.%d%d", cero_tpv, uno_tpv, dos_tpv, tres_tpv];
            break;
        case 4:
            resul = [NSString stringWithFormat:@"0%d.%d%d", cero_tpv, uno_tpv, dos_tpv];
            break;
        case 3:
            resul = [NSString stringWithFormat:@"00.%d%d", cero_tpv, uno_tpv];
            break;
        case 2:
            resul = [NSString stringWithFormat:@"00.0%d", cero_tpv];
            break;
        case 1:
            resul = [NSString stringWithFormat:@"00.00"];
            break;
    }
    
    contador_tpv--;
    
    [_label_cantidad setText:resul];
    
    
    
}// END TECLA BORRAR DIGITOS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//

- (void)ponerMontoEnTransaccionGlobalYAVANZAR{
    
    double monto_semi = [_textfield_tpv.text doubleValue];
    double monto_final = monto_semi / 100.0;
    NSString *string_monto = [NSString stringWithFormat:@"%0.2f", monto_final];
    NSLog(@"MONTO FINAL: %@", string_monto);
    
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
    [objeto_transaccion set_monto_transaccion:string_monto];
    [objeto_transaccion set_tipo_pago_transaccion:@"tarjeta"];
    _textfield_tpv.text = @"";
    _label_cantidad.text = @"00.00";
    contador_tpv = 0;
    
    [self performSegueWithIdentifier: @"continuar" sender: self];
}

@end
