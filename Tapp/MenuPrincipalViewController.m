//
//  MenuPrincipalViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 3/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "MenuPrincipalViewController.h"

@interface MenuPrincipalViewController ()

@end

@implementation MenuPrincipalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}// END VIEWDIDLOAD






///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// COBRAR

- (IBAction)accion_cobrar:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"verificado"]) {
        
        [self validarActivacionCobrar];
   
    }else{
    
    
    NSString *modo_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"modo"];

    if ([modo_traido isEqualToString:@"tpv"]) {
        [self performSegueWithIdentifier: @"tpv" sender: self];
    }else{
    [self performSegueWithIdentifier: @"cobrar" sender: self];
    }
    
    }
}// END ACCION COBRAR

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// USUARIO

- (IBAction)accion_analizar:(id)sender {

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"verificado"]) {
        
        [self validarActivacionUsuario];
        
    }else{
        
    [self performSegueWithIdentifier: @"nip_usuario" sender: self];
    
    }
}// END ACCION USUARIO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// CONFIGURACION

- (IBAction)accion_configurar:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"verificado"]) {
        
        [self validarActivacionConfiguracion];
        
    }else{

    [self performSegueWithIdentifier: @"nip_configuracion" sender: self];
    
    }
}// END ACCION CONFIGURAR

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TOUCH UP

- (IBAction)accion_touch_up:(id)sender {
   
    UIButton *tmp = (UIButton*)sender;
    int wat = (int)tmp.tag;
    switch (wat) {
            
        case 0:
            _imagen_fondo.image = [UIImage imageNamed:@"menu_0.png"];
            break;
        case 1:
            _imagen_fondo.image = [UIImage imageNamed:@"menu_0.png"];
            break;
        case 2:
            _imagen_fondo.image = [UIImage imageNamed:@"menu_0.png"];
            break;
            
    }

}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TOUCH DOWN

- (IBAction)accion_touch_down:(id)sender {
    
    UIButton *tmp = (UIButton*)sender;
    int wat = (int)tmp.tag;
    switch (wat) {
            
        case 0:
            _imagen_fondo.image = [UIImage imageNamed:@"menu_1.png"];
            break;
        case 1:
            _imagen_fondo.image = [UIImage imageNamed:@"menu_2.png"];
            break;
        case 2:
            _imagen_fondo.image = [UIImage imageNamed:@"menu_3.png"];
            break;
            
    }

}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// VALIDAR QUE ESTE ACTIVO EL CORREO

- (void)validarActivacionCobrar{
    
    NSString *correo = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    
    // VERIFICAR SI CUENTA ESTA ACTIVADA
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/verificacion.php?email=%@", correo];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"activo "]) {

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"verificado"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *modo_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"modo"];
        
        if ([modo_traido isEqualToString:@"tpv"]) {
            [self performSegueWithIdentifier: @"tpv" sender: self];
        }else{
            [self performSegueWithIdentifier: @"cobrar" sender: self];
        }
    }else{
        [self crearAlertError];
    }
    
}// END VALIDAR ACTIVACION COBRAR

- (void)validarActivacionConfiguracion{
    
    NSString *correo = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    
    // VERIFICAR SI CUENTA ESTA ACTIVADA
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/verificacion.php?email=%@", correo];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"activo "]) {

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"verificado"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier: @"nip_configuracion" sender: self];
    }else{
        [self crearAlertError];
    }
    
}// END VALIDAR ACTIVACION CONFIGURACION

- (void)validarActivacionUsuario{
    
    NSString *correo = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    
    // VERIFICAR SI CUENTA ESTA ACTIVADA
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/verificacion.php?email=%@", correo];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"activo "]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"verificado"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier: @"nip_usuario" sender: self];
    }else{
        [self crearAlertError];
    }
    
}// END VALIDAR ACTIVACION CONFIGURACION

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT TEXTFIELD EN BLANCO

- (void)crearAlertError{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"Por favor activa tu cuenta. Si no te llega el correo, ponte en contacto con nosotros."
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
