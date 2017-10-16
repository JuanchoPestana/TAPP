//
//  TarjetaReaderViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "TarjetaReaderViewController.h"

@interface TarjetaReaderViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *carrito;
    NSString *dbPathString_productos;
    
    // VARIABLES DE LOCALIZACION
    NSMutableArray *arrayOfLocation;
    CLLocationManager *locationManager;
    CLLocationManager *startlocation;
}

@end

// DATOS TARJETA
NSString *tarjeta_reader_numero_tarjeta;
NSString *tarjeta_reader_cvv;
NSString *tarjeta_reader_fecha;

// DATOS TRANSACCION
NSString *tarjeta_reader_monto_traido;
NSString *tarjeta_reader_correo_recibe;
NSString *tarjeta_reader_fecha_actual;
NSString *tarjeta_reader_tipo_pago;
NSString *tarjeta_reader_numero_orden;
NSString *tarjeta_reader_vendedor;

NSString *tarjeta_reader_fecha_actual_ventas;
NSString *tarjeta_reader_fecha_hora_actual_ventas;
NSString *tarjeta_reader_hora_actual_ventas;


// DATOS COORDENADAS
NSString *tarjeta_reader_latitud;
NSString *tarjeta_reader_longitud;




@implementation TarjetaReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. ACTIVAR LOCALIZACION
    [self activarLocalizacion];

}// END VIEWDIDLOAD


////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// ACCION QUE SIMULA QUE LA TARJETA FUE LEIDA

- (IBAction)accion_tarjeta:(id)sender {
    
    // 1. EMPEZAR ANIMACION
    [self animacion];
    
    // 2. TRAER DATOS DE LA TRANSACCION
    [self traerDatosTransaccion];
    
    // 3. TRAER FECHA ACTUAL Y NUMERO DE ORDEN
    [self traerFechaActual];
    
    // 4. VERIFICAR INTERNET PARA HACER TRANSACCION
    [self verificarInternet];
    
    
}// END ACCION TARJETA

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
    
    tarjeta_reader_latitud = currentlatitude;
    tarjeta_reader_longitud = currentlongitude;
    
    
}// END PONER LATITUD Y LONGITUD EN VARIABLES

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER DATOS DE LA TRANSACCION

- (void)traerDatosTransaccion{
    
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];

    // 1. PONER VALORES DUMMY (EN REALIDAD ESTOS SALEN DEL PLASTICO INSERTADO)
    tarjeta_reader_numero_tarjeta = @"4152313099130713";
    tarjeta_reader_cvv = @"937";
    tarjeta_reader_fecha = @"01/20";
    
    [objeto_transaccion set_numero_tarjeta_transaccion:tarjeta_reader_numero_tarjeta];
    [objeto_transaccion set_cvv_transaccion:tarjeta_reader_cvv];
    [objeto_transaccion set_fecha_vencimiento_transaccion:tarjeta_reader_fecha];
    

    tarjeta_reader_monto_traido = [NSString stringWithFormat:@"%@", [objeto_transaccion get_monto_transaccion]];
    tarjeta_reader_tipo_pago = [NSString stringWithFormat:@"%@", [objeto_transaccion get_tipo_pago_transaccion]];
    
    tarjeta_reader_correo_recibe = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    tarjeta_reader_vendedor = [[NSUserDefaults standardUserDefaults] objectForKey:@"vendedor"];
    
}// END TRAER DATOS TRANSACCION



///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//ANIMACION

- (void)animacion{
    
    NSArray *imagenes = @[@"pantalla_tarjeta_1.png", @"pantalla_tarjeta_2.png", @"pantalla_tarjeta_3.png", @"pantalla_tarjeta_4.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imagenes.count; i++) {
        [images addObject:[UIImage imageNamed:[imagenes objectAtIndex:i]]];
    }
    
    _imageView_animacion.animationImages = images;
    _imageView_animacion.animationDuration = 1.3;
    
    [_imageView_animacion startAnimating];
    
    
}// END ANIMACION

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
    tarjeta_reader_fecha_actual = fechaSemi;
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *fechaSemi2 = [NSString stringWithFormat:@"%@", [dateFormatter2 stringFromDate:[NSDate date]]];
    tarjeta_reader_numero_orden = fechaSemi2;
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
    NSString *fechaSemi3 = [NSString stringWithFormat:@"%@", [dateFormatter3 stringFromDate:[NSDate date]]];
    tarjeta_reader_fecha_actual_ventas = fechaSemi3;
    
    NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *fechaSemi4 = [NSString stringWithFormat:@"%@", [dateFormatter4 stringFromDate:[NSDate date]]];
    tarjeta_reader_fecha_hora_actual_ventas = fechaSemi4;
    
    NSDateFormatter *dateFormatter5 = [[NSDateFormatter alloc] init];
    [dateFormatter5 setDateFormat:@"HH"];
    NSString *fechaSemi5 = [NSString stringWithFormat:@"%@", [dateFormatter5 stringFromDate:[NSDate date]]];
    tarjeta_reader_hora_actual_ventas = fechaSemi5;
    
}// END FECHA ACTUAL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE VERIFICA SI HAY CONEXION A INTERNET

- (void)verificarInternet{
    
    // GINA;
    // ACTIVAR REACHABILITY
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
//         NO HAY
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentarPantallaNoInternet) userInfo:nil repeats:NO];
    
    }else{
//         SI HAY
        
        // 5. REALIZAR TRANSACCION
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
    
    // AQUI HAY QUE HACER TAMBIEN LA TRANSACCION REAL DE PROSA
    // ESTE ES EL QUE LE AGREGA DINERO AL MYSQL DEL QUE RECIBE. SOLO AUMENTA EL TOTAL
    // AQUI HAY QUE VER BIEN QUE SI EL DINERO SALIO DE LA TARJETA, ENTRE EN LA CUENTA.
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/transacciontarjeta.php?recibe=%@&monto=%@", tarjeta_reader_correo_recibe, tarjeta_reader_monto_traido];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
        [self traerCarritoYInsertarVentas];
        [self agregarATransaccionesMYSQL];
        
    }else{
        
//        [self traerCarritoYInsertarVentas];
//        [self agregarATransaccionesMYSQL];
        // GINA:
        // TENGO QUE ACTIVAR LA PANTALLA FAIL Y QUITAR LOS DOS DE ARRIBA DE AQUI
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentarPantallFail) userInfo:nil repeats:NO];
        
    }// END IF SUCCESS
    
    
}// END REALIZAR TRANSACCION

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// INSERTAR EN TABAL MYSQL "TRANSACCIONES"

- (void)agregarATransaccionesMYSQL{
    
    NSString *concepto = @"TPV";
    NSString *correo_paga_transaccion_tarjeta = @"TPV";
    
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/transacciones.php?fecha=%@&tipo=%@&monto=%@&numeroTarjeta=%@&emisor=%@&receptor=%@&concepto=%@&latitud=%@&longitud=%@", tarjeta_reader_fecha_actual, tarjeta_reader_tipo_pago, tarjeta_reader_monto_traido, tarjeta_reader_numero_tarjeta, correo_paga_transaccion_tarjeta, tarjeta_reader_correo_recibe, concepto, tarjeta_reader_latitud, tarjeta_reader_longitud];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
        // PONER FOTO DE SUCCESS EN LA PANTALLA
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(presentarPantallaSuccess) userInfo:nil repeats:NO];
        
        
    }else{
        
        // PONER FOTO DE FAIL EN LA PANTALLA
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentarPantallFail) userInfo:nil repeats:NO];
//        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(presentarPantallaSuccess) userInfo:nil repeats:NO];

        // GINA:
        // BORRAR QUE SE MANDE A PANTALLA SUCCES.. DEJAR EN FAIL AQUI
        
    }// END IF SUCCESS
    
    
}// END AGREGAR A TRANSACCIONES MYSQL

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
    
    NSString *fecha = tarjeta_reader_fecha_actual_ventas;
    NSString *fecha_hora = tarjeta_reader_fecha_hora_actual_ventas;
    NSString *hora = tarjeta_reader_hora_actual_ventas;
    NSString *tipo_pago = tarjeta_reader_tipo_pago;
    NSString *numero_tarjeta = tarjeta_reader_numero_tarjeta;
    NSString *numero_orden = tarjeta_reader_numero_orden;
    NSString *latitud = tarjeta_reader_latitud;
    NSString *longitud = tarjeta_reader_longitud;
    
    // VARIABLES DE SQLITE
    sqlite3 *ventas;
    NSString *dbPathString;
    
    // RUTA SQLITE
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"ventas.db"];
    
    
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &ventas)==SQLITE_OK) {
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO VENTAS (NOMBREPRODUCTO, PALABRACLAVE, PRECIO, DESCRIPCION, FECHA, FECHAHORA, HORA, LATITUD, LONGITUD, TIPOPAGO, NUMEROTARJETA, NUMEROORDEN,VENDEDOR) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", nombre_producto, palabra_clave,precio,descripcion,fecha,fecha_hora,hora,latitud,longitud,tipo_pago,numero_tarjeta,numero_orden,tarjeta_reader_vendedor];
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
// SIGUIENTE PANTALLA

- (void)presentarPantallaSuccess{
    
    [_imageView_animacion stopAnimating];
    _imageView_animacion.image = [UIImage imageNamed:@"pantalla_fail_transaccion.png"];
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];

    
    
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

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// MOVER A SIGUIENTE PANTALLA
- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"firma" sender: self];
    
}// END CAMBIAR PANTALLA

@end
