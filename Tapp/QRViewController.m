//
//  QRViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/26/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "QRViewController.h"


@interface QRViewController ()


@end


@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. CREAR QR CODE
    [self crearQR];

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
    
}// END CONFIGURAR SWIPE

- (IBAction)accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//

- (void)crearQR{

NSString *string_qr = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    
CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
[filter setDefaults];

NSData *data = [string_qr dataUsingEncoding:NSUTF8StringEncoding];
[filter setValue:data forKey:@"inputMessage"];

CIImage *outputImage = [filter outputImage];
CIContext *context = [CIContext contextWithOptions:nil];
CGImageRef cgImage = [context createCGImage:outputImage
                                   fromRect:[outputImage extent]];

UIImage *image = [UIImage imageWithCGImage:cgImage scale:1. orientation:UIImageOrientationUp];

// Resize without interpolating
UIImage *resized = [self resizeImage:image
                         withQuality:kCGInterpolationNone
                                rate:5.0];

self.imageView.image = resized;

CGImageRelease(cgImage);

}// END VIEWDIDLOAD

// =============================================================================
#pragma mark - Private

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}




@end
