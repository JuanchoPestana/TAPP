//
//  FirmaModoTiendaViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 8/29/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "FirmaModoTiendaViewController.h"

@interface FirmaModoTiendaViewController ()

@end

NSString *fecha_firma_modo_tienda;

@implementation FirmaModoTiendaViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. INICIALIZAR
    [self inicializaciones];
    
    // 2. TRAER FECHA ACTUAL
    [self traerFechaActual];

}// END VIEWDIDLOAD

- (void)inicializaciones{
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 6.0;
    opacity = 1.0;
    
    _imageView_resultado.hidden = YES;
    
}// END INICIALIZACIONES

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PARTE DE DRAWING

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//

- (IBAction)accion_borrar:(id)sender {

    self.mainImage.image = nil;

}// END ACCION BORRAR


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//

- (IBAction)accion_continuar:(id)sender {

    UIGraphicsBeginImageContextWithOptions(_mainImage.bounds.size, NO,0.0);
    [_mainImage.image drawInRect:CGRectMake(0, 0, _mainImage.frame.size.width, _mainImage.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageView_resultado.image = SaveImage;
    
    [self guardarImagenServidor];
    
}// END ACCION CONTINUAR

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GUARDAR IMAGEN EN SERVIDOR

- (void)guardarImagenServidor{
    
    NSString *nombre_usuario = [[NSUserDefaults standardUserDefaults] objectForKey:@"nombre"];

    NSString *nombre_firma = [NSString stringWithFormat:@"%@-%@", nombre_usuario, fecha_firma_modo_tienda];
    
    [[NSUserDefaults standardUserDefaults] setObject:nombre_firma forKey:@"firma"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    NSString *urlString = @"http://tapp.dataprodb.com/tapp_final/imagenes/uploadfirma.php";
    
    //Convert your UIImage to NSDate
    UIImage *imagen_firma_img =_imageView_resultado.image;
    
    NSData *imageData = UIImagePNGRepresentation(imagen_firma_img);
    
    
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
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.png\"\r\n",nombre_firma] dataUsingEncoding:NSUTF8StringEncoding]];
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
                
             }
             
             //Do what you want with your return data.
             
         }];
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];

    
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
    fecha_firma_modo_tienda = fechaSemi;
    
    
}// END FECHA ACTUAL

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// MOVER A SIGUIENTE PANTALLA
- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"ticket" sender: self];
    
}// END CAMBIAR PANTALLA


@end
