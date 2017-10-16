//
//  TarjetaCamaraViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 5/1/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "TarjetaCamaraViewController.h"

@interface TarjetaCamaraViewController ()

@end

CardIOView *cardIOView;

@implementation TarjetaCamaraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. PRESENTAR CAMARA
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(presentarCamara) userInfo:nil repeats:NO];

}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE

- (void)configurarSwipe{
    
    _swipe_right.numberOfTouchesRequired = 2;
    
}// END CONFIGURAR SWIPE
- (IBAction)accion_swipe_right:(id)sender {

    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END ACCION SWIPE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION INGRESAR MANUALMENTE
- (IBAction)accion_ingresar_manualmente:(id)sender {
    
    // AQUI MANDAR A PANTALLA DE INGRESAR MANUALMENTE
    
}// END INGRESAR MANUALMENTE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE PRE CARGA CONFIGURACIONES DEL CARD IO
- (void)preCargarCard{
    
    [CardIOUtilities preload];
    
    if (![CardIOUtilities canReadCardWithCamera]) {
        // Hide your "Scan Card" button, or take other appropriate action...
    }
}// END PRE CARGAR CARD IO

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {}

- (void)cardIOView:(CardIOView *)cardIOView didScanCard:(CardIOCreditCardInfo *)info {
    if (info) {
        
//        self.textfield_numero_tarjeta.text = info.cardNumber;
        
//        [_textfield_fecha becomeFirstResponder];
//        _imagen_boton_cancelarCamara.hidden = YES;
//        _boton_cancelar_camara.enabled = NO;
//
        
        NSLog(@"%@", info.cardNumber);
        
    }
    else {
    }
    
    [cardIOView removeFromSuperview];
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE PRESENTA CAMARA

- (void)presentarCamara{
    
    CGRect rect = CGRectMake(215, 85, 600, 600);
    
    cardIOView = [[CardIOView alloc] initWithFrame:rect];
    cardIOView.delegate = self;
    
    cardIOView.hideCardIOLogo = YES;
    
    [self.view addSubview:cardIOView];
    
}// END PRESENTAR CAMARA

@end
