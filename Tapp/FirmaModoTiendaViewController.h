//
//  FirmaModoTiendaViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 8/29/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirmaModoTiendaViewController : UIViewController{
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}



// ACCION BORRAR
- (IBAction)accion_borrar:(id)sender;

// ACCION CONTINUAR
- (IBAction)accion_continuar:(id)sender;


// IMAGE VIEWS PARA FIRMA
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;


// IMAGE VIEW PARA PROBAR RESULTADO
@property (weak, nonatomic) IBOutlet UIImageView *imageView_resultado;



@end
