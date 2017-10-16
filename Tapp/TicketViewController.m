//
//  TicketViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 7/27/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "TicketViewController.h"
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface TicketViewController ()

@end

int numero_fondo;

@implementation TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];

    // 2. PONER LOGO
    [self ponerLogoEnImagen];
    
    // 3. PONER COLORES EN FONDOS
    [self ponerColoresExistentes];
    
    // 4. PONER NOMBRE
    [self ponerNombre];
    
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
    
    [self performSegueWithIdentifier: @"regresar" sender: self];
    
}// END SWIPE RIGHT

- (IBAction)accion_swipe_left:(id)sender {
    
    [self performSegueWithIdentifier: @"continuar" sender: self];
    
}// END SWIPE LEFT

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
// ACCIONES FONDO

- (IBAction)accion_fondo_uno:(id)sender {
    
    numero_fondo = 1;
    _fondo_principal.image = [UIImage imageNamed:@"configurar_ticket_1_a.png"];

}// END ACCION FONDO UNO

- (IBAction)accion_fondo_dos:(id)sender {

    numero_fondo = 2;
    _fondo_principal.image = [UIImage imageNamed:@"configurar_ticket_2_a.png"];

}// END ACCION FONDO DOS

- (IBAction)accion_fondo_tres:(id)sender {
    
    numero_fondo = 3;
    _fondo_principal.image = [UIImage imageNamed:@"configurar_ticket_3_a.png"];

}// END ACCION FONDO TRES

- (IBAction)accion_letras:(id)sender {

    numero_fondo = 0;

}// END ACCION LETRAS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION PONER COLOR AL QUE ESTE SELECCIONADO

- (void)ponerColoresExistentes{
    
    // LETRAS
    NSString *r1_traido_letras = [[NSUserDefaults standardUserDefaults] objectForKey:@"letras_r"];
    NSString *g1_traido_letras = [[NSUserDefaults standardUserDefaults] objectForKey:@"letras_g"];
    NSString *b1_traido_letras = [[NSUserDefaults standardUserDefaults] objectForKey:@"letras_b"];
    int r1_traido_letras_int = [r1_traido_letras intValue];
    int g1_traido_letras_int = [g1_traido_letras intValue];
    int b1_traido_letras_int = [b1_traido_letras intValue];
    _nombre.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    _monto.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    _mxn.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    _nombre.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    _fecha.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    _fecha_variable.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    _tarjeta.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    _numeros_tarjeta.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    _asteriscos.textColor = Rgb2UIColor(r1_traido_letras_int, g1_traido_letras_int, b1_traido_letras_int);
    
    // FONDO UNO
    NSString *r1_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1"];
    NSString *g1_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"g1"];
    NSString *b1_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"b1"];
    int r1_traido_int = [r1_traido intValue];
    int g1_traido_int = [g1_traido intValue];
    int b1_traido_int = [b1_traido intValue];
    _fondo_uno.backgroundColor = Rgb2UIColor(r1_traido_int, g1_traido_int, b1_traido_int);

    // FONDO DOS
    NSString *r2_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"r2"];
    NSString *g2_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"g2"];
    NSString *b2_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"b2"];
    int r2_traido_int = [r2_traido intValue];
    int g2_traido_int = [g2_traido intValue];
    int b2_traido_int = [b2_traido intValue];
    _fondo_dos.backgroundColor = Rgb2UIColor(r2_traido_int, g2_traido_int, b2_traido_int);
    
    // FONDO TRES
    NSString *r3_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"r3"];
    NSString *g3_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"g3"];
    NSString *b3_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"b3"];
    int r3_traido_int = [r3_traido intValue];
    int g3_traido_int = [g3_traido intValue];
    int b3_traido_int = [b3_traido intValue];
    _fondo_tres.backgroundColor = Rgb2UIColor(r3_traido_int, g3_traido_int, b3_traido_int);
    
}// END PONER COLORES EXISTENTES


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION PONER COLOR AL QUE ESTE SELECCIONADO

- (IBAction)accion_poner_color:(id)sender {

    int r = [_textfield_r.text intValue];
    int g = [_textfield_g.text intValue];
    int b = [_textfield_b.text intValue];

    
    switch (numero_fondo) {
            
        case 0:
            _nombre.textColor = Rgb2UIColor(r, g, b);
            _monto.textColor = Rgb2UIColor(r, g, b);
            _mxn.textColor = Rgb2UIColor(r, g, b);
            _nombre.textColor = Rgb2UIColor(r, g, b);
            _fecha.textColor = Rgb2UIColor(r, g, b);
            _fecha_variable.textColor = Rgb2UIColor(r, g, b);
            _tarjeta.textColor = Rgb2UIColor(r, g, b);
            _numeros_tarjeta.textColor = Rgb2UIColor(r, g, b);
            _asteriscos.textColor = Rgb2UIColor(r, g, b);


            [[NSUserDefaults standardUserDefaults] setObject:_textfield_r.text forKey:@"letras_r"];
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_g.text forKey:@"letras_g"];
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_b.text forKey:@"letras_b"];
            
            break;
        case 1:
            _fondo_uno.backgroundColor = Rgb2UIColor(r, g, b);
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_r.text forKey:@"r1"];
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_g.text forKey:@"g1"];
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_b.text forKey:@"b1"];
        
            break;
        case 2:
            _fondo_dos.backgroundColor = Rgb2UIColor(r, g, b);
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_r.text forKey:@"r2"];
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_g.text forKey:@"g2"];
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_b.text forKey:@"b2"];
            
            break;
        case 3:
            _fondo_tres.backgroundColor = Rgb2UIColor(r, g, b);
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_r.text forKey:@"r3"];
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_g.text forKey:@"g3"];
            [[NSUserDefaults standardUserDefaults] setObject:_textfield_b.text forKey:@"b3"];
            

            break;
            
        default:
            break;
            
    }// END SWITCH
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}// END ACCION PONER COLOR

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PONE LOGO EN IMAGEVIEW

- (void)ponerNombre{
    NSString *nombre;
    NSString *nombre_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"nombre"];
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    nombre = [[nombre_traido componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @" "];
    
    _nombre.text = nombre;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PONE LOGO EN IMAGEVIEW

- (void)ponerLogoEnImagen{
    
    NSString *logo_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];
    
    NSString *nombreFoto = [NSString stringWithFormat:@"%@.png", logo_traido];
    _logo.image = [self loadImage: nombreFoto];
    
}

- (UIImage*)loadImage:(NSString*)imageName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    
    return [UIImage imageWithContentsOfFile:fullPath];
    
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//



@end
