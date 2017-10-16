//
//  TransaccionQRViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/27/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "TransaccionQRViewController.h"

@interface TransaccionQRViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *carrito;
    NSString *dbPathString_productos;
    
    // VARIABLES DE LOCALIZACION
    NSMutableArray *arrayOfLocation;
    CLLocationManager *locationManager;
    CLLocationManager *startlocation;
    
}// END INTERFACE


@end

NSString *correo_paga_transaccion_qr;
NSString *monto_traido_transaccion_qr;
NSString *correo_recibe_transaccion_qr;
NSString *fecha_actual_transaccion_qr;
NSString *tipo_pago_transaccion_qr;
NSString *numero_orden_qr;

NSString *fecha_actual_ventas_transaccion_qr;
NSString *fecha_hora_actual_ventas_transaccion_qr;
NSString *hora_actual_ventas_transaccion_qr;


NSString *latitud_qr;
NSString *longitud_qr;

@implementation TransaccionQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. INICIALIZAR INDICADOR
    [self.activity_indicator startAnimating];
    
    // 1. ACTIVAR LOCALIZACION
    [self activarLocalizacion];
    
    // 2. TRAER DATOS PARA TRANSACCION
    [self traerDatosTransaccion];
    
    // 3. TRAER FECHA ACTUAL
    [self traerFechaActual];
    
    // 4. VERIFICAR SI HAY INTERNET
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verificarInternet) userInfo:nil repeats:NO];
    
    
    
}// END VIEWDIDLOAD

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
    
    latitud_qr = currentlatitude;
    longitud_qr = currentlongitude;
    
}// END PONER LATITUD Y LONGITUD EN VARIABLES


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER EMAIL DEL CLIENTE

- (void)traerDatosTransaccion{
    
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
    correo_paga_transaccion_qr = [NSString stringWithFormat:@"%@", [objeto_transaccion get_mail_qrcode_transaccion]];
    monto_traido_transaccion_qr = [NSString stringWithFormat:@"%@", [objeto_transaccion get_monto_transaccion]];
    tipo_pago_transaccion_qr = [NSString stringWithFormat:@"%@", [objeto_transaccion get_tipo_pago_transaccion]];
    
    correo_recibe_transaccion_qr = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    
    
}// END TRAER DATOS TRANSACCION


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE VERIFICA SI HAY CONEXION A INTERNET

- (void)verificarInternet{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        // NO HAY
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentarPantallaNoInternet) userInfo:nil repeats:NO];
        
    }else{
        // SI HAY
        
        // 3. REALIZAR TRANSACCION
        [self realizarTransaccion];
        
    }// END IF INTERNET
    
}// END VERIFICAR INTERNET

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE RALIZA TRANSACCION

- (void)realizarTransaccion{
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/transaccionqr.php?paga=%@&recibe=%@&monto=%@", correo_paga_transaccion_qr, correo_recibe_transaccion_qr, monto_traido_transaccion_qr];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
        [self agregarATransaccionesMYSQL];
        [self traerCarritoYInsertarVentas];
        
    }else{
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentarPantallFail) userInfo:nil repeats:NO];
        
    }// END IF SUCCESS
    
    
}// END REALIZAR TRANSACCION

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
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    
    if (sqlite3_open([dbPathString_productos UTF8String], &carrito)==SQLITE_OK) {
        
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
    
    NSString *fecha = fecha_actual_ventas_transaccion_qr;
    NSString *fecha_hora = fecha_hora_actual_ventas_transaccion_qr;
    NSString *hora = hora_actual_ventas_transaccion_qr;
    NSString *latitud = latitud_qr;
    NSString *longitud = longitud_qr;
    NSString *tipo_pago = tipo_pago_transaccion_qr;
    NSString *numero_tarjeta = @"NULO";
    NSString *numero_orden = numero_orden_qr;
    
    
    // VARIABLES DE SQLITE
    sqlite3 *ventas;
    NSString *dbPathString;
    
    // RUTA SQLITE
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"ventas.db"];
    
    
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &ventas)==SQLITE_OK) {
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO VENTAS (NOMBREPRODUCTO, PALABRACLAVE, PRECIO, DESCRIPCION, FECHA, FECHAHORA, HORA, LATITUD, LONGITUD, TIPOPAGO, NUMEROTARJETA, NUMEROORDEN) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", nombre_producto, palabra_clave,precio,descripcion,fecha,fecha_hora,hora,latitud,longitud,tipo_pago,numero_tarjeta,numero_orden];
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
// INSERTAR EN TABAL MYSQL "TRANSACCIONES"

- (void)agregarATransaccionesMYSQL{
    
    NSString *numero_tarjeta = @"NULO";
    NSString *concepto = @"NULO";
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/transacciones.php?fecha=%@&tipo=%@&monto=%@&numeroTarjeta=%@&emisor=%@&receptor=%@&concepto=%@&latitud=%@&longitud=%@", fecha_actual_transaccion_qr, tipo_pago_transaccion_qr, monto_traido_transaccion_qr, numero_tarjeta, correo_paga_transaccion_qr, correo_recibe_transaccion_qr, concepto, latitud_qr, longitud_qr];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentarPantallaSuccess) userInfo:nil repeats:NO];
        
    }else{
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentarPantallFail) userInfo:nil repeats:NO];
        
        
    }// END IF SUCCESS
    
    
}// END AGREGAR A TRANSACCIONES MYSQL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SIGUIENTE PANTALLA

- (void)presentarPantallaSuccess{
    
    [self performSegueWithIdentifier: @"success" sender: self];
    
}// END PRESENTAR PANTALLA SUCCESS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PANTALLA DE NO HAY INTERNET

- (void)presentarPantallaNoInternet{
    
    [self performSegueWithIdentifier: @"wifi" sender: self];
    
    
}// END PRESENTAR PANTALLA SUCCESS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PANTALLA DE FAIL

- (void)presentarPantallFail{
    
    [self performSegueWithIdentifier: @"fail" sender: self];
    
    
}// END PRESENTAR PANTALLA FAIL

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
    fecha_actual_transaccion_qr = fechaSemi;
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *fechaSemi2 = [NSString stringWithFormat:@"%@", [dateFormatter2 stringFromDate:[NSDate date]]];
    numero_orden_qr = fechaSemi2;
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
    NSString *fechaSemi3 = [NSString stringWithFormat:@"%@", [dateFormatter3 stringFromDate:[NSDate date]]];
    fecha_actual_ventas_transaccion_qr = fechaSemi3;
    
    NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *fechaSemi4 = [NSString stringWithFormat:@"%@", [dateFormatter4 stringFromDate:[NSDate date]]];
    fecha_hora_actual_ventas_transaccion_qr = fechaSemi4;
    
    NSDateFormatter *dateFormatter5 = [[NSDateFormatter alloc] init];
    [dateFormatter5 setDateFormat:@"HH"];
    NSString *fechaSemi5 = [NSString stringWithFormat:@"%@", [dateFormatter5 stringFromDate:[NSDate date]]];
    hora_actual_ventas_transaccion_qr = fechaSemi5;
    
}// END FECHA ACTUAL

@end
