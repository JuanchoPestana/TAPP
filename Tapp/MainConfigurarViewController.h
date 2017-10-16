//
//  MainConfigurarViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 3/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"


@interface MainConfigurarViewController : UIViewController 

// SWIPE OUTLET
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;

// ACCION SWIPE
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)iphone_accion_swipe_right:(id)sender;



// ACCION PANTALLA NOMBRE
- (IBAction)accion_pantalla_nombre:(id)sender;

// ACCION PANTALLA NIP
- (IBAction)accion_pantalla_nip:(id)sender;

// ACCION PANTALLA # CUENTA
- (IBAction)accion_pantalla_cuenta:(id)sender;

// ACCION PANTALLA CLABE
- (IBAction)accion_pantalla_clabe:(id)sender;

// ACCION PANTALLA MODO
- (IBAction)accion_pantalla_modo:(id)sender;

// ACCION PANTALLA PRODUCTOS
- (IBAction)accion_pantalla_productos:(id)sender;

// ACCION PANTALLA CATEGORIAS
- (IBAction)accion_pantalla_categorias:(id)sender;

// ACCION PANTALLA VENDEDOR
- (IBAction)accion_pantalla_vendedor:(id)sender;

// ACCION PANTALLA LOGO
- (IBAction)accion_pantalla_logo:(id)sender;

// ACCION PANTALLA TICKET
- (IBAction)accion_pantalla_ticket:(id)sender;


// ACCIONES BOTONES HIGHLIGHT
- (IBAction)accion_touch_up:(id)sender;
- (IBAction)accion_touch_down:(id)sender;

// OUTLET IMAGEN FONDO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo_configuracion;




@end
