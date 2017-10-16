//
//  VendedorMainViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 6/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Vendedor.h"



@interface VendedorMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// SWIPE OUTLET
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;
- (IBAction)accion_swipe_left:(id)sender;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *iphone_swipe_right;
- (IBAction)iphone_accion_swipe_right:(id)sender;


// ACCIONES SWIPE
- (IBAction)accion_swipe_right:(id)sender;

// ACCION PANTALLA AGREGAR
- (IBAction)accion_pantalla_agregar:(id)sender;
- (IBAction)iphone_accion_pantalla_agregar:(id)sender;


// TABLEVIEW VENDEDORES
@property (weak, nonatomic) IBOutlet UITableView *tableview_vendedores;


// LABEL VENDEDOR ACTUAL NOMBRE
@property (weak, nonatomic) IBOutlet UILabel *label_vendedor_actual;

// LABEL VENDEDOR ACTUAL APELLIDO
@property (weak, nonatomic) IBOutlet UILabel *label_vendedor_actual_apellido;

// LABEL VENDEDOR ACTUAL NOMINA
@property (weak, nonatomic) IBOutlet UILabel *label_vendedor_actual_nomina;


@end
