//
//  ErrorNormalVC.m
//  Tapp
//
//  Created by Juancho Pestana on 3/4/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "ErrorNormalVC.h"

@interface ErrorNormalVC ()

@end

@implementation ErrorNormalVC

- (void)viewDidLoad {
    [super viewDidLoad];


}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION QUE REGRESA A PANTALLA INICIAL

- (IBAction)accion_inicial:(id)sender {
    
    [self regresarAPantallaAnterior];
    
}// END ACCION INICIAL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE REGRESA A PANTALLA INICIAL


- (void)regresarAPantallaAnterior{
    
    [self performSegueWithIdentifier: @"inicial" sender: self];
    
}


@end