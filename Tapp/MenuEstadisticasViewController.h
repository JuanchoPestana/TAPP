//
//  MenuEstadisticasViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 9/3/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuEstadisticasViewController : UIViewController 


// SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
- (IBAction)accion_swipe_right:(id)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
- (IBAction)accion_swipe_left:(id)sender;

// LABELS FECHAS
@property (weak, nonatomic) IBOutlet UILabel *label_fecha_inferior;
@property (weak, nonatomic) IBOutlet UILabel *label_fecha_superior;

// DATE PICKER 1
@property (weak, nonatomic) IBOutlet UIDatePicker *date_picker;
- (IBAction)accion_date_picker:(id)sender;

// DATE PICKER 2
@property (weak, nonatomic) IBOutlet UIDatePicker *date_picker_2;
- (IBAction)accion_date_picker_2:(id)sender;

@end
