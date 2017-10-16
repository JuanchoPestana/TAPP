//
//  MainAnalizarViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 3/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachibility.h"


@interface MainAnalizarViewController : UIViewController

// SWIPE OUTLET
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_regresar;

// ACCION SWIPE
- (IBAction)accion_regresar:(id)sender;

// LABEL NOMBRE
@property (weak, nonatomic) IBOutlet UILabel *label_nombre_usuario;

// LABEL INICIAL
@property (weak, nonatomic) IBOutlet UILabel *label_inicial;

// LABEL MONTO
@property (weak, nonatomic) IBOutlet UILabel *label_monto_actual;


// PANTALLA QR CODE
- (IBAction)accion_pantalla_qr:(id)sender;



// PANTALLA ESTADISTICAS UNO
- (IBAction)accion_estadisticas_uno:(id)sender;


// PANTALLA HISTORIAL
- (IBAction)accion_pantalla_historial:(id)sender;






// PANTALLA ENVIAR



// PANTALA RETIRAR


// LOGO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_logo;


@end
