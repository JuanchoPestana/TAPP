//
//  CrearProductoUnoViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 3/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Producto.h"
#import "Categoria.h"
#import <RSKImageCropper/RSKImageCropper.h>
#import "RSKImageCropper.h"


@interface CrearProductoUnoViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, UITableViewDelegate, UITableViewDataSource>

// SWIPE OUTLET
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;

// ACCION SWIPE
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_swipe_left:(id)sender;


// OUTLETS TEXTFIELDS
@property (weak, nonatomic) IBOutlet UITextField *textfield_nombre;
@property (weak, nonatomic) IBOutlet UITextField *textfield_palabra_clave;
@property (weak, nonatomic) IBOutlet UITextField *textfield_precio;

// LABEL PRECIO
@property (weak, nonatomic) IBOutlet UILabel *label_precio;


// OUTLET TEXTVIEW
@property (weak, nonatomic) IBOutlet UITextView *textview_descripcion_input;

// IMAGEN PRODUCTO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_producto;

// IMAGEN ICONO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_icono;

// TABLEVIEW CATEGORIAS
@property (weak, nonatomic) IBOutlet UITableView *table_view;



// BOTON PARA PANTALLA IMAGEN
- (IBAction)accion_seleccionar_imagen:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *boton_seleccionar_imagen;

// IMAGEN FONDO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo;



@end
