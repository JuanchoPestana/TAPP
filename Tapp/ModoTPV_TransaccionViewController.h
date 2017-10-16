//
//  ModoTPV_TransaccionViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 6/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachibility.h"
#import "Transaccion.h"
#import "sqlite3.h"
#import <CoreLocation/CoreLocation.h>



@interface ModoTPV_TransaccionViewController : UIViewController <CLLocationManagerDelegate>

// BOTON ACCION INSERTO TARJETA
- (IBAction)accion_inserto_tarjeta:(id)sender;

// IMAGE VIEW ANIMACION 
@property (weak, nonatomic) IBOutlet UIImageView *imageView_animacion;



@end
