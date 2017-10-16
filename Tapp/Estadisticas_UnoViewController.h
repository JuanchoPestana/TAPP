//
//  Estadisticas_UnoViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 8/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "sqlite3.h"
#import "Venta.h"
#import "Reachibility.h"


@interface Estadisticas_UnoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


// SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
- (IBAction)accion_swipe_right:(id)sender;

// SCROLLVIEW
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


// TABLEVIEW VENTAS
@property (weak, nonatomic) IBOutlet UITableView *tableView_ventas;

// TABLEVIEW PRODUCTOS
@property (weak, nonatomic) IBOutlet UITableView *tableView_productos;

// TABLEVIEW ESTADISTICAS
@property (weak, nonatomic) IBOutlet UITableView *tableView_estadisticas;


// LABELS CHART ESTADISTICAS
@property (weak, nonatomic) IBOutlet UILabel *label_arriba_chart;
@property (weak, nonatomic) IBOutlet UILabel *label_abajo_chart;


// ACCION EXPORTAR A EXCEL
- (IBAction)accion_exportar_excel:(id)sender;



@end
