//
//  TransaccionTarjetaViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachibility.h"
#import "Transaccion.h"
#import "sqlite3.h"
#import <CoreLocation/CoreLocation.h>


@interface TransaccionTarjetaViewController : UIViewController <CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_indicator;



@end
