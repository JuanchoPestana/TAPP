//
//  RegistroWifiVC.m
//  Tapp
//
//  Created by Juancho Pestana on 3/4/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "RegistroWifiVC.h"

@interface RegistroWifiVC ()

@end

@implementation RegistroWifiVC

- (void)viewDidLoad {
    [super viewDidLoad];



}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION QUE REGRESA A PANTALLA DE CREANDO CUENTA

- (IBAction)accion_regresar:(id)sender {
    
    [self regresarAPantallaAnterior];
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE REGRESA A PANTALLA DE CREANDO CUENTA

- (void)regresarAPantallaAnterior{
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}

@end