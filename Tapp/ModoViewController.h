//
//  ModoViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModoViewController : UIViewController

// OUTLET SWIPE RIGHT
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;


// ACCION SWIPE RIGHT
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_iphone_swipe_right:(id)sender;



// ACCION TIENDA
- (IBAction)accion_tienda:(id)sender;


// ACCION TPV
- (IBAction)accion_tpv:(id)sender;


// IMAGEN FONDO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo;




// ACCIONES UP Y DOWN
- (IBAction)accion_up:(id)sender;
- (IBAction)accion_down:(id)sender;

@end
