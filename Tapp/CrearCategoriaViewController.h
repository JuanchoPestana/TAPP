//
//  CrearCategoriaViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/5/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Categoria.h"
#import <RSKImageCropper/RSKImageCropper.h>
#import "RSKImageCropper.h"

@interface CrearCategoriaViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>


// OUTLETS CATEGORIAS

@property (weak, nonatomic) IBOutlet UITextField *textfield_nombre_categoria;

@property (weak, nonatomic) IBOutlet UIImageView *imagen_categoria;

@property (weak, nonatomic) IBOutlet UIButton *boton_seleccionar_imagen;
@property (weak, nonatomic) IBOutlet UIButton *boton_seleccionar_icono;


// ACCIONES

- (IBAction)accion_imagenes:(id)sender;
- (IBAction)accion_iconos:(id)sender;


// OUTLETS SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;


// ACCIONES SWIPE
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_swipe_left:(id)sender;

// IMAGEN FONDO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo;



@end
