//
//  CrearVendedorViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 6/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "CrearVendedorViewController.h"

@interface CrearVendedorViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *vendedores;
    NSString *dbPathString;
    
}// END INTERFACE


@end

@implementation CrearVendedorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPE TRANSICION
    [self configurarSwipe];
    
    // 2. CONFIGURAR TEXTFIELD
    [self configurarTextfield];

}// END VIEWDILOAD

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

- (IBAction)accion_swipe_left:(id)sender {
    [self insertarVendedor];
}// END ACCION SWIPE LEFT

- (IBAction)accion_swipe_right:(id)sender {
    [self performSegueWithIdentifier: @"regresar" sender: self];
}// END ACCION SWIPE RIGHT

- (IBAction)iphone_accion_swipe_right:(id)sender {
    [self performSegueWithIdentifier: @"regresar" sender: self];
}// END IPHONE SWIPE RIGHT

- (IBAction)iphone_accion_swipe_left:(id)sender {
    [self insertarVendedor];
}// END IPHONE SWIPE LEFT

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// CONFIGURAR TEXTFIELD

- (void)configurarTextfield{
    
    // NOMBRE
    [_textfield_nombre becomeFirstResponder];
    _textfield_nombre.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    [_textfield_nombre setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_nombre setBorderStyle:UITextBorderStyleNone]; //clear borders
    _textfield_nombre.keyboardAppearance = UIKeyboardAppearanceAlert;
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Nombre" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_nombre.attributedPlaceholder = str1;
    _textfield_nombre.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_nombre.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _textfield_nombre.tag = 1;
    _textfield_nombre.delegate = self;
    
    // APELLIDO
    [_textfield_apellido becomeFirstResponder];
    _textfield_apellido.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    [_textfield_apellido setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_apellido setBorderStyle:UITextBorderStyleNone]; //clear borders
    _textfield_apellido.keyboardAppearance = UIKeyboardAppearanceAlert;
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Apellido" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_apellido.attributedPlaceholder = str2;
    _textfield_apellido.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_apellido.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _textfield_apellido.tag = 2;
    _textfield_apellido.delegate = self;
    
    // NOMINA
    [_textfield_nomina becomeFirstResponder];
    _textfield_nomina.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    [_textfield_nomina setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_nomina setBorderStyle:UITextBorderStyleNone]; //clear borders
    _textfield_nomina.keyboardAppearance = UIKeyboardAppearanceAlert;
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Apodo o Nómina" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_nomina.attributedPlaceholder = str3;
    _textfield_nomina.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_nomina.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _textfield_nomina.tag = 3;
    _textfield_nomina.delegate = self;
    
    
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
// METODO QUE INSERTA PRODUCTO EN BASE DE DATOS

- (void)insertarVendedor{
    
    NSString *string_nombre = _textfield_nombre.text;
    NSString *string_apellido = _textfield_apellido.text;
    NSString *string_nomina = _textfield_nomina.text;

    
    // RUTA SQLITE
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"vendedores.db"];
    
    
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &vendedores)==SQLITE_OK) {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO VENDEDORES (NOMBRE, APELLIDO, NOMINA) values ('%@','%@','%@')",
                                string_nombre, string_apellido, string_nomina];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(vendedores, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            
            [self performSegueWithIdentifier: @"continuar" sender: self];
            
        }
        sqlite3_close(vendedores);
    }
    
}// END INSERTAR CORREO TEMPORAL



@end
