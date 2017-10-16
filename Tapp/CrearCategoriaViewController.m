//
//  CrearCategoriaViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/5/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "CrearCategoriaViewController.h"

@interface CrearCategoriaViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *categorias;
    NSString *dbPathString;
    
}// END INTERFACE


@end
UIImagePickerController *imagePickerController_categoria;

bool nombre_categoria_disponible;

@implementation CrearCategoriaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 0. ESCONDER NAVIGATION BAR
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    nombre_categoria_disponible = true;
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. CONFIGURAR TEXTFIELDS
    [self configurarTextfield];

}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE

// METODO QUE CONFIGURAR SWIPE
- (void)configurarSwipe{
    
    _swipe_right.numberOfTouchesRequired = 2;
    _swipe_left.numberOfTouchesRequired = 2;
    
}// END CONFIGURAR SWIPE

- (IBAction)accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"right" sender: self];

}

- (IBAction)accion_swipe_left:(id)sender {
    
    nombre_categoria_disponible = true;

    
    if ([_textfield_nombre_categoria.text isEqualToString:@""]) {
        [self crearAlertError];
    
    }else{
        
        [self verificarSiExisteCategoria];
        
   
    }// END IF ELSE

}// END SWIPE LEFT

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// BLOQUAR COPY PASTE ASSIST
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    UITextInputAssistantItem* item = [textField inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE INSERTA PRODUCTO EN BASE DE DATOS

- (void)insertarCategoria{
    
    NSString *string_nombre = _textfield_nombre_categoria.text;
  
    NSString *string_nombre_imagen = [NSString stringWithFormat:@"categoria%@.png", string_nombre];
    
    // GUARDAR IMAGEN EN DOCUMENTS FOLDER
    [self saveImage: _imagen_categoria.image nombre: string_nombre_imagen];
    
    // RUTA SQLITE
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"categorias.db"];
    
    
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &categorias)==SQLITE_OK) {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO CATEGORIAS (CATEGORIA, NOMBREIMAGEN) values ('%@','%@')",
                                string_nombre, string_nombre_imagen];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(categorias, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            
            [self performSegueWithIdentifier: @"left" sender: self];
            
        }
        sqlite3_close(categorias);
    }
    
}// END INSERTAR CORREO TEMPORAL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE CONFIGURA TEXTFIELDS


// CONFIGURA TEXTFIELD
- (void)configurarTextfield{
    
    // NOMBRE
    [_textfield_nombre_categoria becomeFirstResponder];
    _textfield_nombre_categoria.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_textfield_nombre_categoria setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_nombre_categoria setBorderStyle:UITextBorderStyleNone]; //clear borders
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Nombre" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.textfield_nombre_categoria.attributedPlaceholder = str1;
    _textfield_nombre_categoria.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_nombre_categoria.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;

    _textfield_nombre_categoria.tag = 1;
    _textfield_nombre_categoria.delegate = self;
    
}// END CONFIGURAR TEXTFIELD


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PARA PRESENTAR LA GALERIA DE FOTOS
- (IBAction)accion_imagenes:(id)sender {
    
    imagePickerController_categoria = [[UIImagePickerController alloc] init];
    imagePickerController_categoria.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController_categoria.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController_categoria.delegate = self;
    imagePickerController_categoria.modalPresentationStyle = UIModalPresentationPopover;
    imagePickerController_categoria.popoverPresentationController.sourceRect = self.boton_seleccionar_imagen.frame;
    imagePickerController_categoria.popoverPresentationController.sourceView = self.view;
    UIPopoverPresentationController *presentationController = imagePickerController_categoria.popoverPresentationController;
    
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:imagePickerController_categoria animated:YES completion:nil];
    
}// END PRESENTAR GALERIA DE FOTOS


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imagePickerController_categoria dismissViewControllerAnimated:YES completion:nil];
    //        _imagen_seleccionada.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = self;
    
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//
#pragma mark - RSKImageCropViewControllerDelegate

//////////////////////////////////////////// DELEGATE

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.imagen_categoria.image = croppedImage;
    _imagen_fondo.image = [UIImage imageNamed:@"pantalla_crear_categoria_1.png"];
    [_boton_seleccionar_icono setTitle:@"" forState:UIControlStateNormal];
    [_boton_seleccionar_imagen setTitle:@"" forState:UIControlStateNormal];

    [self.navigationController popViewControllerAnimated:YES];
}
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////// DATA SOURCE

// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGSize maskSize;
    if ([controller isPortraitInterfaceOrientation]) {
        maskSize = CGSizeMake(250, 250);
    } else {
        maskSize = CGSizeMake(220, 220);
    }
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    
    return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:point1];
    [triangle addLineToPoint:point2];
    [triangle addLineToPoint:point3];
    [triangle closePath];
    
    return triangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    // If the image is not rotated, then the movement rect coincides with the mask rect.
    return controller.maskRect;
}


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GUARDAR IMAGEN EN DOCUMENTS FOLDER

- (void)saveImage:(UIImage *) image nombre: (NSString *) imageName {
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    
    
}// END GUARDAR IMAGEN DOCUMENTS FOLDER


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PARA PRESENTAR LA GALERIA DE ICONOS

- (IBAction)accion_iconos:(id)sender {

}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE VERIFICA SI NO EXISTE YA LA CATEGORIA
-(void)verificarSiExisteCategoria{
    
    NSString *nombre_escrito = _textfield_nombre_categoria.text;
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"categorias.db"];
    
    dbPathString = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString UTF8String], &categorias)==SQLITE_OK) {
        
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CATEGORIAS"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(categorias, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *columna_nombre_categoria = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                if ([nombre_escrito isEqualToString:columna_nombre_categoria]) {
                    nombre_categoria_disponible = false;
                }// END IF
                
            }// END WHILE
            
        }// END SQLITE OK
        
        
    }// END IF SQLITE OPEN
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(insertarConTimer) userInfo:nil repeats:NO];

    
}// END ACTUALIZAR COLLECTION VIEW

- (void)insertarConTimer{
    
    if (nombre_categoria_disponible) {
        [self insertarCategoria];
    }else{
        [self crearAlertNombreNoDisponible];
    }
}// END INSERTAR CON TIMER


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT FALTA ERROR

- (void)crearAlertError{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"Debes llenar todos los datos que se piden."
                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    // BOTON CANCELAR
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    [alertTextfieldBlanco addAction:cancelAction];
    
    [self presentViewController:alertTextfieldBlanco animated:YES completion:nil];
    
}// END CREAR ALERTA ERROR

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT FALTA INFORMACION

- (void)crearAlertNombreNoDisponible{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"Esa categoria ya existe."
                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    // BOTON CANCELAR
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    [alertTextfieldBlanco addAction:cancelAction];
    
    [self presentViewController:alertTextfieldBlanco animated:YES completion:nil];
    
}// END CREAR ALERTA USUARIO YA EXISTE


@end
