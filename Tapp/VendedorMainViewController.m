//
//  VendedorMainViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 6/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "VendedorMainViewController.h"

@interface VendedorMainViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *vendedores;
    NSString *dbPathString_vendedores;
    NSMutableArray *arrayOfVendedores;
    
    // VARIABLES DE SQLITE
    
    NSString *vendedor_seleccionado;
    
    NSString *resul;
    
    
    
}// END INTERFACE

@end

NSString *nombre_vendedor_seleccionado;
NSString *apellido_vendedor_seleccionado;



@implementation VendedorMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPES
    [self configurarSwipe];
    
    // 2. INICIALIZACIONES
    [self inicializaciones];
    
    // 3. TRAER VENDEDORES
    [self traerVendedores];
    
    // 4. PONER VENDEDOR ACTUAL
    [self ponerActualLabel];


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

    [self performSegueWithIdentifier: @"menu" sender: self];

}

// IPHONE ACCION SWIPE RIGHT
- (IBAction)iphone_accion_swipe_right:(id)sender {

    [self performSegueWithIdentifier: @"menu" sender: self];

}// END IPHONE ACCION SWIPE RIGHT


- (IBAction)accion_swipe_left:(id)sender {

    [self performSegueWithIdentifier: @"seleccionado" sender: self];


}// END ACCION SWIPE LEFT


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PANTALLA AGREGAR

- (IBAction)accion_pantalla_agregar:(id)sender {
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}

- (IBAction)iphone_accion_pantalla_agregar:(id)sender {

    [self performSegueWithIdentifier: @"continuar" sender: self];

}// END IPHONE PANTALLA AGREGAR

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// INICIALIZACIONES

- (void)inicializaciones{
    
    
    arrayOfVendedores = [[NSMutableArray alloc]init];
    
    [_tableview_vendedores setDelegate:self];
    _tableview_vendedores.backgroundColor = [UIColor clearColor];
    _tableview_vendedores.opaque = NO;
    _tableview_vendedores.backgroundView = nil;
    
    [_tableview_vendedores setShowsHorizontalScrollIndicator:NO];
    [_tableview_vendedores setShowsVerticalScrollIndicator:NO];
    _tableview_vendedores.allowsSelection = YES;
    
    
}// END INICIALIZACIONES

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER VENDEDORES

- (void)traerVendedores{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"vendedores.db"];
    dbPathString_vendedores = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_vendedores UTF8String], &vendedores)==SQLITE_OK) {
        
        [arrayOfVendedores removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM VENDEDORES"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(vendedores, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_nombre_vendedor = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_apellido_vendedor = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *columna_nomina_vendedor = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];

                nombre_vendedor_seleccionado = columna_nombre_vendedor;
                apellido_vendedor_seleccionado = columna_apellido_vendedor;
                
                // PONER DATOS EN OBJETO
                Vendedor *vendedor = [[Vendedor alloc]init];
                [vendedor set_nombre_vendedor:columna_nombre_vendedor];
                [vendedor set_apellido_vendedor:columna_apellido_vendedor];
                [vendedor set_nomina_vendedor:columna_nomina_vendedor];

                [arrayOfVendedores addObject:vendedor];
            }
        }
        
        [[self tableview_vendedores]reloadData];
        
    }// END IF SQLITE OPEN
    
    
    
}// END TRAER VENDEDORES

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TABLEVIEW CATEGORIAS

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:25.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:21.0];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.backgroundColor = [UIColor clearColor];
    
    
}// END FORMAT CELL

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfVendedores count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    Vendedor *aVen = [arrayOfVendedores objectAtIndex:indexPath.row];
    NSString *titulo_tableview = [[NSString alloc]initWithFormat:@"%@", aVen.get_nomina_vendedor];
    NSString *subtitulo_tableview = [[NSString alloc]initWithFormat:@"%@ %@", aVen.get_nombre_vendedor, aVen.get_apellido_vendedor];

    
    cell.textLabel.text = titulo_tableview;
    cell.detailTextLabel.text = subtitulo_tableview;

    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Vendedor *p = [arrayOfVendedores objectAtIndex:indexPath.row];
    vendedor_seleccionado = [NSString stringWithFormat:@"%s", [p.get_nomina_vendedor UTF8String]];
    [[NSUserDefaults standardUserDefaults] setObject:vendedor_seleccionado forKey:@"vendedor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *nombre_actual = [NSString stringWithFormat:@"%s", [p.get_nombre_vendedor UTF8String]];
    [[NSUserDefaults standardUserDefaults] setObject:nombre_actual forKey:@"vendedor_nombre"];
    
    NSString *apellido_actual = [NSString stringWithFormat:@"%s", [p.get_apellido_vendedor UTF8String]];
    [[NSUserDefaults standardUserDefaults] setObject:apellido_actual forKey:@"vendedor_apellido"];

    [self ponerActualLabel];
    
}// END SELECCIONAR FILA

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PONER ACTUAL EN LABEL

- (void)ponerActualLabel{
    
    // NOMINA VENDEDOR
    NSString *vendedor_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"vendedor"];
    NSString *vendedor_traido_nombre = [[NSUserDefaults standardUserDefaults] objectForKey:@"vendedor_nombre"];
    NSString *vendedor_traido_apellido = [[NSUserDefaults standardUserDefaults] objectForKey:@"vendedor_apellido"];

    _label_vendedor_actual_nomina.text = [vendedor_traido uppercaseString];
    _label_vendedor_actual.text = [vendedor_traido_nombre uppercaseString];
    _label_vendedor_actual_apellido.text = [vendedor_traido_apellido uppercaseString];

    
}// END PONER ACTUAL EN LABEL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//



@end
