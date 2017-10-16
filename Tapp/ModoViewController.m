//
//  ModoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "ModoViewController.h"

@interface ModoViewController ()

@end

@implementation ModoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. TRAER ACTUAL
//    [self traerActual];
    
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
//    _swipe_left.numberOfTouchesRequired = 2;
    
}// END CONFIGURAR SWIPE


- (IBAction)accion_swipe_right:(id)sender {
    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END ACCION SWIPE RIGHT

- (IBAction)accion_iphone_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END IPHONE ACCION SWIPE RIGHT


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE TRAE VALOR ACTUAL DEL MODO

//- (void)traerActual{
//   
//    NSString *modo_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"modo"];
//    
//}// END TRAER ACTUAL


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION TIENDA
// * ESTAN AL REVES, ME EQUIVOQUE

- (IBAction)accion_tienda:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"tpv" forKey:@"modo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION TPV

- (IBAction)accion_tpv:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"tienda" forKey:@"modo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCIONES UP Y DOWN PARA FONDO DE PANTALLA


- (IBAction)accion_up:(id)sender {
    
    UIButton *tmp = (UIButton*)sender;
    int wat = (int)tmp.tag;
    switch (wat) {
            
        case 0:
            _imagen_fondo.image = [UIImage imageNamed:@"modo_0.png"];
            break;
        case 1:
            _imagen_fondo.image = [UIImage imageNamed:@"modo_0.png"];
            break;
        }

}// END UP

- (IBAction)accion_down:(id)sender {
    
    UIButton *tmp = (UIButton*)sender;
    int wat = (int)tmp.tag;
    switch (wat) {
            
        case 0:
            _imagen_fondo.image = [UIImage imageNamed:@"modo_2.png"];
            break;
        case 1:
            _imagen_fondo.image = [UIImage imageNamed:@"modo_1.png"];
            break;
    }
    
}// END DOWN
@end