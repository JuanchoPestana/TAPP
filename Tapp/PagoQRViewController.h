//
//  PagoQRViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/26/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Transaccion.h"



@interface PagoQRViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>


// VIEW PARA QR READER
@property (weak, nonatomic) IBOutlet UIView *vista;



// SWIPE BACK OUTLET
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;

// SWIPE BACK ACCION
- (IBAction)accion_swipe_right:(id)sender;


@end
