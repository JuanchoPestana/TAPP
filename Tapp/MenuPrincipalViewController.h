//
//  MenuPrincipalViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 3/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuPrincipalViewController : UIViewController

// IMAGEN FONDO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo;

// BOTONES
@property (weak, nonatomic) IBOutlet UIButton *boton_configurar;
@property (weak, nonatomic) IBOutlet UIButton *boton_cobrar;
@property (weak, nonatomic) IBOutlet UIButton *boton_analizar;

// ACCIONES
- (IBAction)accion_configurar:(id)sender;
- (IBAction)accion_cobrar:(id)sender;
- (IBAction)accion_analizar:(id)sender;


// TOUCH DOWN
- (IBAction)accion_touch_down:(id)sender;



// TOUCH UP
- (IBAction)accion_touch_up:(id)sender;

@end
