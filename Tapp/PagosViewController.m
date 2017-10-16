//
//  PagosViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/12/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "PagosViewController.h"

@interface PagosViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString_productos;
    
    sqlite3 *carrito;
    NSString *dbPathString_carrito;
    
    // VARIABLES DE LOCALIZACION
    NSMutableArray *arrayOfLocation;
    CLLocationManager *locationManager;
    CLLocationManager *startlocation;
    
    
}// END INTERFACE


@end


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// VARIABLES GLOBALES

double total_acumulado;
NSString *fecha_actual_efectivo;
NSString *numero_orden_efectivo;

NSString *fecha_actual_efectivo_ventas;
NSString *fecha_hora_actual_efectivo_ventas;
NSString *hora_actual_efectivo_ventas;


NSString *latitud_efectivo;
NSString *longitud_efectivo;

@implementation PagosViewController

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// VIEW DIDLOAD

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];

    // 2. INICIALIZAR BOTONES
    [self incializarBotones];
    
    // 3. INICIALIZACIONES GENERALES
    [self inicializaciones];
    
    // 4. CALCULAR TOTAL Y PONERLO EN OBJETO GLOBAL Y EN LABLE
    [self ponerMontoEnTransaccionGlobal];
    
    // 5. ACTIVAR LOCALIZACION
    [self activarLocalizacion];

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
// INICIALIZACIONES

- (void)inicializaciones{
    
    total_acumulado = 0.0;
    
}// END INICIALIZACIONES


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// INICIALIZAR BOTONES IMAGENES FONDO
- (void)incializarBotones{
    
//    [_boton_analizar setImage:[UIImage imageNamed:@"ana.png"] forState:UIControlStateHighlighted];
//    [_boton_cobrar setImage:[UIImage imageNamed:@"cob.png"] forState:UIControlStateHighlighted];
//    [_boton_configurar setImage:[UIImage imageNamed:@"conf.png"] forState:UIControlStateHighlighted];
    
}// END INICIALIZAR BOTONES

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE ACTIVA PROCESOS DE LOCALIZACION
- (void)activarLocalizacion{
    
    //INICIALIZAR PROCESOS DE LOCALIZACION
    locationManager = [[CLLocationManager alloc]init];
    [locationManager requestAlwaysAuthorization]; // AQUI ESTA EL PERMISO PARA LOCATION (PASAR AL APP DELEGATE)
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
}// END LOCALIZACION

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSString *currentlatitude = [[NSString alloc]initWithFormat:@"%.10f", newLocation.coordinate.latitude];
    NSString *currentlongitude = [[NSString alloc]initWithFormat:@"%.10f", newLocation.coordinate.longitude];
    
    latitud_efectivo = currentlatitude;
    longitud_efectivo = currentlongitude;
    
}// END PONER LATITUD Y LONGITUD EN VARIABLES

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER BASE DE DATOS CARRITO Y SUMAR TOTAL

- (void)ponerMontoEnTransaccionGlobal{
    
    NSString *string_monto;
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"carrito.db"];
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT PRECIO FROM CARRITO"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_precio_producto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                NSCharacterSet *trim = [NSCharacterSet characterSetWithCharactersInString:@","];
                NSString *string_trimeado = [[columna_precio_producto componentsSeparatedByCharactersInSet:trim] componentsJoinedByString:@""];
                
                double double_trimeado = [string_trimeado doubleValue];
                total_acumulado += double_trimeado;
                
            }
        }
        
        
    }// END IF SQLITE OPEN
    
    // PONER TOTAL EN OBJETO TRANSACCION SIN COMA Y EN LABEL TRANSACCION CON COMA, SOLO VISUAL
    string_monto = [NSString stringWithFormat:@"%0.2f", total_acumulado];
    [self metodoPonerComas];
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
    [objeto_transaccion set_monto_transaccion:string_monto];
    
    
}// END PONER MONTO EN TRANSACCION GLOBAL


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//
// METODO QUE PONE COMAS EN EL NUMERO
- (void)metodoPonerComas{
    
    double monto_i;
    monto_i = total_acumulado;
    monto_i = monto_i + 0.001;
    
    
    int millon, centenar, diezmil, mil, cien, diez, uno, decima, centesima;
    millon = monto_i / 1000000;
    centenar = monto_i / 100000;
    diezmil = monto_i / 10000;
    mil = monto_i / 1000;
    cien = monto_i / 100;
    diez = monto_i / 10;
    uno = monto_i / 1;
    decima = monto_i / 0.1;
    centesima = monto_i / 0.01;
    
    int centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin, mil_fin, diezmil_fin, cienmil_fin;
    centena_fin = ((monto_i - (mil * 1000)) / 100);
    decena_fin = ((monto_i - (mil * 1000) - (centena_fin * 100)) / 10);
    unidad_fin = ((monto_i - (mil * 1000) - (centena_fin * 100) - (decena_fin * 10)) / 1);
    decima_fin = ((monto_i - (mil * 1000) - (centena_fin * 100) - (decena_fin * 10) - (unidad_fin * 1)) / 0.1);
    centesima_fin = ((monto_i - (mil * 1000) - (centena_fin * 100) - (decena_fin * 10) - (unidad_fin * 1) - (decima_fin * 0.1)) / 0.01);
    
    mil_fin = ((monto_i - (diezmil * 10000)) / 1000 );
    diezmil_fin = ((monto_i - (centenar * 100000)) / 10000);
    cienmil_fin = ((monto_i - (millon * 1000000)) / 100000);
    
    
    if (monto_i < 1000) {
        
        monto_i = monto_i - 0.001;
        
        NSString *montosemi = [NSString stringWithFormat:@"$ %0.2f MXN", monto_i];
        _label_total.text = montosemi;
        
    }else if(diezmil == 0){
        NSString *monto = [NSString stringWithFormat:@"$ %d,%d%d%d.%d%d MXN", mil, centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin];
        _label_total.text = monto;
        
    }else if(centenar == 0){
        NSString *monto = [NSString stringWithFormat:@"$ %d%d,%d%d%d.%d%d MXN", diezmil, mil_fin, centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin];
        _label_total.text = monto;
    }else if(millon == 0){
        NSString *monto = [NSString stringWithFormat:@"$ %d%d%d,%d%d%d.%d%d MXN", centenar, diezmil_fin, mil_fin, centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin];
        _label_total.text = monto;
    }else{
        NSString *monto = [NSString stringWithFormat:@"$ %d,%d%d%d,%d%d%d.%d%d MXN", millon, cienmil_fin, diezmil_fin, mil_fin, centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin];
        _label_total.text = monto;
        
    }
    
}// END PONER COMAS


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// QR CODE

- (IBAction)accion_pantalla_qrcode:(id)sender {
    
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
    [objeto_transaccion set_tipo_pago_transaccion:@"qrcode"];
    
    [self performSegueWithIdentifier: @"qrcode" sender: self];

}


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION EFECTIVO

- (IBAction)accion_efectivo:(id)sender {
    
    // 1. TRAER FECHA
    [self traerFechaActual];

    // 2. INSERTAR VENTAS
    [self traerCarritoYInsertarVentas];
    
    // 3. TRAER LOCATION
    [locationManager stopUpdatingLocation];
    
    // 4. MOVER A SIGUIENTE PANTALLA
    [self performSegueWithIdentifier: @"ticketefectivo" sender: self];

    
    
}// END ACCION EFECTIVO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION TARJETA READER

- (IBAction)accion_tarjeta_reader:(id)sender {

    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
    [objeto_transaccion set_tipo_pago_transaccion:@"tarjeta"];
    
    [self performSegueWithIdentifier: @"tarjetareader" sender: self];

}// END ACCION TARJETA READER

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION TARJETA CAMARA

- (IBAction)accion_tarjeta_camara:(id)sender {
   
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
    [objeto_transaccion set_tipo_pago_transaccion:@"tarjeta"];
    
    [self performSegueWithIdentifier: @"tarjetacamara" sender: self];
    
}// END ACCION TARJETA CAMARA


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER CARRITO Y MANDAR INSERTAR EN VENTAS LOCAL

- (void)traerCarritoYInsertarVentas{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"carrito.db"];
    
    dbPathString_carrito = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    
    if (sqlite3_open([dbPathString_carrito UTF8String], &carrito)==SQLITE_OK) {
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CARRITO"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(carrito, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *nombreProducto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *palabraClave = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *precio = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *descripcion = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                
                [self insertarVentas:nombreProducto :palabraClave :precio :descripcion];
                
            }// END WHILE
        }// END PREPARE
        
        
    }// END IF SQLITE OPEN
    
}// END INSERTAR CORREO TEMPORAL


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// FUNCION QUE INSERTA EN VENTAS LOCAL RECIBIENDO PARAMETROS

- (void)insertarVentas:(NSString *)nombre_producto :(NSString *)palabra_clave :(NSString *)precio :(NSString *)descripcion{
    
    
    NSString *fecha = fecha_actual_efectivo_ventas;
    NSString *fecha_hora = fecha_hora_actual_efectivo_ventas;
    NSString *hora = hora_actual_efectivo_ventas;
    NSString *latitud = latitud_efectivo;
    NSString *longitud = longitud_efectivo;
    NSString *tipo_pago = @"efectivo";
    NSString *numero_tarjeta = @"EFECTIVO";
    NSString *numero_orden = numero_orden_efectivo;
    NSString *vendedor = [[NSUserDefaults standardUserDefaults] objectForKey:@"vendedor"];

    
    
    // VARIABLES DE SQLITE
    sqlite3 *ventas;
    NSString *dbPathString;
    
    // RUTA SQLITE
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"ventas.db"];
    
    
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &ventas)==SQLITE_OK) {
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO VENTAS (NOMBREPRODUCTO, PALABRACLAVE, PRECIO, DESCRIPCION, FECHA, FECHAHORA, HORA, LATITUD, LONGITUD, TIPOPAGO, NUMEROTARJETA, NUMEROORDEN,VENDEDOR) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", nombre_producto, palabra_clave,precio,descripcion,fecha,fecha_hora,hora,latitud,longitud,tipo_pago,numero_tarjeta,numero_orden,vendedor];
        const char *insert_stmt = [insertStmt UTF8String];
        if (sqlite3_exec(ventas, insert_stmt, NULL, NULL, &error)==SQLITE_OK){}// EXECUTE
        
        sqlite3_close(ventas);
        
    }// END IF OPEN
    
}// END INSERTAR A VENTAS LOCAL

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
    fecha_actual_efectivo = fechaSemi;
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *fechaSemi2 = [NSString stringWithFormat:@"%@", [dateFormatter2 stringFromDate:[NSDate date]]];
    numero_orden_efectivo = fechaSemi2;
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
    NSString *fechaSemi3 = [NSString stringWithFormat:@"%@", [dateFormatter3 stringFromDate:[NSDate date]]];
    fecha_actual_efectivo_ventas = fechaSemi3;
    
    NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *fechaSemi4 = [NSString stringWithFormat:@"%@", [dateFormatter4 stringFromDate:[NSDate date]]];
    fecha_hora_actual_efectivo_ventas = fechaSemi4;
    
    NSDateFormatter *dateFormatter5 = [[NSDateFormatter alloc] init];
    [dateFormatter5 setDateFormat:@"HH"];
    NSString *fechaSemi5 = [NSString stringWithFormat:@"%@", [dateFormatter5 stringFromDate:[NSDate date]]];
    hora_actual_efectivo_ventas = fechaSemi5;
    
}// END FECHA ACTUAL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCIONES UP Y DOWN PARA HIGHLIGHT STATE

- (IBAction)accion_up:(id)sender {

    UIButton *tmp = (UIButton*)sender;
    int wat = (int)tmp.tag;
    switch (wat) {
            
        case 0:
            _imagen_fondo_pagos.image = [UIImage imageNamed:@"pantalla_pagos_0.png"];
            break;
        case 1:
            _imagen_fondo_pagos.image = [UIImage imageNamed:@"pantalla_pagos_0.png"];
            break;
        case 2:
            _imagen_fondo_pagos.image = [UIImage imageNamed:@"pantalla_pagos_0.png"];
            break;
        case 3:
            _imagen_fondo_pagos.image = [UIImage imageNamed:@"pantalla_pagos_0.png"];
            break;
            
            
    }

}// END UP

- (IBAction)accion_down:(id)sender {
    
    UIButton *tmp = (UIButton*)sender;
    int wat = (int)tmp.tag;
    switch (wat) {
            
        case 1:
            _imagen_fondo_pagos.image = [UIImage imageNamed:@"pantalla_pagos_1.png"];
            break;
        case 2:
            _imagen_fondo_pagos.image = [UIImage imageNamed:@"pantalla_pagos_2.png"];
            break;
        }

    
}// END DOWN

@end
