//
//  LogoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 7/23/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "LogoViewController.h"

@interface LogoViewController ()

@end
UIImagePickerController *imagePickerController_logo;
NSString *fecha_logo;

@implementation LogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 0. ESCONDER NAVIGATION BAR
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    
    // 3. PONER LOGO EN IMAGEVIE
//    NSString *nombreFoto = [NSString stringWithFormat:@"%@.png", fecha_logo];
    NSString *logo_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];
    _imagen_logo.image = [self loadImage: logo_traido];
    
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
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END ACCION SWIPE RIGHT

- (IBAction)accion_swipe_left:(id)sender {
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}// END ACCION SWIPE LEFT

- (IBAction)iphone_accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];
    
}// END IPHONE ACCION SWIPE RIGHT


- (IBAction)iphone_accion_swipe_left:(id)sender {
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}// END IPHONE ACCION SWIPE LEFT
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE VERIFICA SI HAY CONEXION A INTERNET

- (void)verificarInternet{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        // NO HAY
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(crearAlertError) userInfo:nil repeats:NO];
        
    }else{
        // SI HAY
        
        // 1. TRAER MONTO
        [self seleccionar_logo];
        
    }// END IF INTERNET
    
}// END VERIFICAR INTERNET


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PRESENTAR GALERIA DE FOTOS

- (IBAction)accion_seleccionar_logo:(id)sender {
    
    [self verificarInternet];
    
}// END PRESENTAR GALERIA DE FOTOS

- (void)seleccionar_logo{
    
    imagePickerController_logo = [[UIImagePickerController alloc] init];
    imagePickerController_logo.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController_logo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController_logo.delegate = self;
    imagePickerController_logo.modalPresentationStyle = UIModalPresentationPopover;
    imagePickerController_logo.popoverPresentationController.sourceRect = self.boton_seleccionar_imagen.frame;
    imagePickerController_logo.popoverPresentationController.sourceView = self.view;
    UIPopoverPresentationController *presentationController = imagePickerController_logo.popoverPresentationController;
    
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:imagePickerController_logo animated:YES completion:nil];

    
}// END SELECCIONAR LOGO

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imagePickerController_logo dismissViewControllerAnimated:YES completion:nil];
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
    self.imagen_logo.image = croppedImage;
//    _imagen_fondo.image = [UIImage imageNamed:@"pantalla_crear_categoria_1.png"];
//    [_boton_seleccionar_icono setTitle:@"" forState:UIControlStateNormal];
//    [_boton_seleccionar_imagen setTitle:@"" forState:UIControlStateNormal];
    // 2. TRAER FECHA ACTUAL
    [self traerFechaActual];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(guardarImagenes) userInfo:nil repeats:NO];

    
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
// GUARDAR IMAGENES

- (void)guardarImagenes{
    
    [self guardarImagenServidor];
    [self saveImage:_imagen_logo.image nombre:fecha_logo];
    
}// END GUARDAR IMAGENES


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////L
// GUARDAR IMAGEN EN DOCUMENTS FOLDER

- (void)saveImage:(UIImage *) image nombre: (NSString *) imageName {
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    
    
}// END GUARDAR IMAGEN DOCUMENTS FOLDER

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GUARDAR IMAGEN EN SERVIDOR

- (void)guardarImagenServidor{
    
    [[NSUserDefaults standardUserDefaults] setObject:fecha_logo forKey:@"logo"];

    
    NSString *urlString = @"http://tapp.dataprodb.com/tapp_final/imagenes/uploadlogo.php";
    
    //Convert your UIImage to NSDate
    UIImage *imagen_logo_img =_imagen_logo.image;
    
    NSData *imageData = UIImagePNGRepresentation(imagen_logo_img);
    
    
    if (imageData != nil)
    {
        NSString *filenames = [NSString stringWithFormat:@"imagenPrueba"];      //set name here
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //I use a method called randomStringWithLength: to create a unique name for the file, so when all the aapps are sending files to the server, none of them will have the same name:
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.png\"\r\n",fecha_logo] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        //I chose to run my code async so the app could continue doing stuff while the image was sent to the server.
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             
             NSData *returnData = data;
             if (returnData) {
                 // ESTE IF ES SOLO PARA QUITAR EL WARNING
             }
             
             //Do what you want with your return data.
             
         }];
    
    }
    
}// END GUARDAR IMAGEN SERVIDOR


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE AGARRA FECHA ACTUAL
- (void)traerFechaActual{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
    NSString *fechaSemi = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    fecha_logo = fechaSemi;
    
    [[NSUserDefaults standardUserDefaults] setObject:fecha_logo forKey:@"logo"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}// END FECHA ACTUAL


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PONE LOGO EN IMAGEVIEW

- (UIImage*)loadImage:(NSString*)imageName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    
    return [UIImage imageWithContentsOfFile:fullPath];
    
}


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT TEXTFIELD EN BLANCO

- (void)crearAlertError{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"No hay conexión a internet."
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
