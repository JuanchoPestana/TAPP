//
//  TarjetaReaderViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaccion.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachibility.h"
#import "sqlite3.h"





@interface TarjetaReaderViewController : UIViewController <CLLocationManagerDelegate>

// BOTON QUE SIMULA LA ENTRADA DE UNA TARJETA
- (IBAction)accion_tarjeta:(id)sender;

// IMAGEVIEW PARA PONER ANIMACION
@property (weak, nonatomic) IBOutlet UIImageView *imageView_animacion;


@end
