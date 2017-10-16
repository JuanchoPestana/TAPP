//
//  TarjetaCamaraViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 5/1/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIO.h"

@interface TarjetaCamaraViewController : UIViewController <CardIOViewDelegate>

// SWIPE BACK
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;


// ACCION SWIPE
- (IBAction)accion_swipe_right:(id)sender;


// ACCION INGRESAR MANUALMENTE
- (IBAction)accion_ingresar_manualmente:(id)sender;


@end
