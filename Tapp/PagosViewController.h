//
//  PagosViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/12/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Transaccion.h"
#import "Reachibility.h"
#import <CoreLocation/CoreLocation.h>



@interface PagosViewController : UIViewController <UIGestureRecognizerDelegate, CLLocationManagerDelegate>

// SWIPE RIGHT
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;


// ACCION SWIPE RIGHT
- (IBAction)accion_swipe_right:(id)sender;


// LABEL TOTAL
@property (weak, nonatomic) IBOutlet UILabel *label_total;


// ACCION PANTALLA QR CODE
- (IBAction)accion_pantalla_qrcode:(id)sender;


// ACCION EFECTIVO
- (IBAction)accion_efectivo:(id)sender;


// ACCION TARJETA READER
- (IBAction)accion_tarjeta_reader:(id)sender;


// ACCION UP Y DOWN
- (IBAction)accion_up:(id)sender;
- (IBAction)accion_down:(id)sender;

// IMAGEN FONDO PAGOS
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo_pagos;

// ACCION TARJETA CAMARA
- (IBAction)accion_tarjeta_camara:(id)sender;


@end
