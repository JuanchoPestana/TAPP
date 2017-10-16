//
//  RegistroEmailVC.m
//  Tapp
//
//  Created by Juancho Pestana on 2/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "RegistroEmailVC.h"

@interface RegistroEmailVC ()

@end

@implementation RegistroEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPE TRANSICION
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
    
    _swipe_left.numberOfTouchesRequired = 2;
    
}// END CONFIGURAR SWIPE


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// CONFIGURAR TEXTFIELD

// CONFIGURA TEXTFIELD
- (void)configurarTextfield{
    
    [_textfield_email_registro becomeFirstResponder];
    _textfield_email_registro.keyboardAppearance = UIKeyboardAppearanceAlert;
    
   
    [_textfield_email_registro setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_email_registro setBorderStyle:UITextBorderStyleNone]; //clear borders
    _textfield_email_registro.keyboardAppearance = UIKeyboardAppearanceAlert;
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Correo electrónico" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_email_registro.attributedPlaceholder = str1;
    _textfield_email_registro.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_email_registro.tag = 1;
    _textfield_email_registro.delegate = self;

    
}// END CONFIGURAR TEXTFIELD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// BLOQUAR COPY PASTE ASSIST
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    UITextInputAssistantItem* item = [textField inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
}


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCIONES


// METODO QUE MANDA A SIGUIENTE PANTALLA AL HACER SWIPE
- (IBAction)accion_swipe_left:(id)sender {
    
    // VERIFICAR SI NO ESTA VACIO EL TEXTFIELD
    if ([_textfield_email_registro.text isEqualToString:@""]) {
        [self crearAlertTextfieldBlanco];
    }else{
        // VERIFICAR SI CORREO YA ESTA OCUPADO
    
     Registro *objeto_registro = [Registro registroGlobal];
    [objeto_registro setCorreo:_textfield_email_registro.text];
    
    [self performSegueWithIdentifier: @"left" sender: self];
        
    }// END IF ALERT

}// END SWIPE LEFT

- (IBAction)iphone_accion_swipe_left:(id)sender {

    // VERIFICAR SI NO ESTA VACIO EL TEXTFIELD
    if ([_textfield_email_registro.text isEqualToString:@""]) {
        [self crearAlertTextfieldBlanco];
    }else{
        // VERIFICAR SI CORREO YA ESTA OCUPADO
        
        Registro *objeto_registro = [Registro registroGlobal];
        [objeto_registro setCorreo:_textfield_email_registro.text];
        
        [self performSegueWithIdentifier: @"left" sender: self];
        
    }// END IF ALERT

}// END ACCION SWIPE IPHONE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT TEXTFIELD EN BLANCO

- (void)crearAlertTextfieldBlanco{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"Debes ingresar un correo."
                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    // BOTON CANCELAR
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    [alertTextfieldBlanco addAction:cancelAction];
    
    [self presentViewController:alertTextfieldBlanco animated:YES completion:nil];
    
}// END CREAR ALERTA USUARIO YA EXISTE



@end
