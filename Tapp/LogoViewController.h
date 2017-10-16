//
//  LogoViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 7/23/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSKImageCropper/RSKImageCropper.h>
#import "RSKImageCropper.h"
#import "Reachibility.h"


@interface LogoViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

// SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
- (IBAction)accion_swipe_right:(id)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;
- (IBAction)iphone_accion_swipe_right:(id)sender;


@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
- (IBAction)accion_swipe_left:(id)sender;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_left;
- (IBAction)iphone_accion_swipe_left:(id)sender;



// IMAGE VIEW
@property (weak, nonatomic) IBOutlet UIImageView *imagen_logo;


// ACCION SELECCIONAR LOGO
- (IBAction)accion_seleccionar_logo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *boton_seleccionar_imagen;


@end
