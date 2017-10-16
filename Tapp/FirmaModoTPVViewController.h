//
//  FirmaModoTPVViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 8/29/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirmaModoTPVViewController : UIViewController{
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}


// IMAGEVIEWS PARA DIBUJAR
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;

// IMAGEVIEW PARA GUARDAR
@property (weak, nonatomic) IBOutlet UIImageView *imageView_guardar;


// ACCIONES
- (IBAction)accion_continuar:(id)sender;
- (IBAction)accion_borrar:(id)sender;



@end
