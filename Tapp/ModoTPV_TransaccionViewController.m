//
//  ModoTPV_TransaccionViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 6/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "ModoTPV_TransaccionViewController.h"

@interface ModoTPV_TransaccionViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *carrito;
    NSString *dbPathString_productos;
    
    // VARIABLES DE LOCALIZACION
    NSMutableArray *arrayOfLocation;
    CLLocationManager *locationManager;
    CLLocationManager *startlocation;
    
}// END INTERFACE

@end

// DATOS TARJETA
NSString *tpv_numero_tarjeta;
NSString *tpv_cvv;
NSString *tpv_fecha;


// DATOS TRANSACCION
NSString *tpv_monto;
NSString *tpv_correo_recibe;
NSString *tpv_fecha_actual;
NSString *tpv_tipo_pago;
NSString *tpv_numero_orden;
NSString *tpv_vendedor;

NSString *tpv_fecha_ventas;
NSString *tpv_fecha_hora_ventas;
NSString *tpv_hora_ventas;


// DATOS COORDENADAS
NSString *tpv_latitud;
NSString *tpv_longitud;
@implementation ModoTPV_TransaccionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. ACTIVAR LOCALIZACION
    [self activarLocalizacion];
    
    // 2. TRAER DATOS PARA TRANSACCION
    [self traerDatosTransaccion];
    
    // 3. TRAER FECHA ACTUAL
    [self traerFechaActual];
    
    



}// END VIEWDIDLOAD



///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION QUE SIMULA QUE SE INSERTO LA TARJETA

- (IBAction)accion_inserto_tarjeta:(id)sender {
    
    // 1. EMPEZAR ANIMACION
    [self animacion];
    
    // 2. TRAER DATOS DE LA TRANSACCION
    [self traerDatosTransaccion];
    
    // 3. TRAER FECHA ACTUAL Y NUMERO DE ORDEN
    [self traerFechaActual];
    
    // 4. VERIFICAR INTERNET PARA HACER TRANSACCION
    [self verificarInternet];
    
    
//    // 2. PONER VALORES EN OBJETO DE TRANSACCION
//    [self ponerValoresEnObjeto];
    
    
}// END ACCION QUE SIMULA UN INPUT DE TARJETA

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

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//// METODO QUE PONE VALORES AGARRADOS DEL LECTOR, EN OBJETO PARA LA TRANSACCION
//- (void)ponerValoresEnObjeto{
//    
//    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
//    [objeto_transaccion set_numero_tarjeta_transaccion:tpv_numero_tarjeta];
//    [objeto_transaccion set_cvv_transaccion:tpv_cvv];
//    [objeto_transaccion set_fecha_vencimiento_transaccion:tpv_fecha];
//    
//}// END PONER VALORES EN OBJETO

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
    
    tpv_latitud = currentlatitude;
    tpv_longitud = currentlongitude;
    
    
}// END PONER LATITUD Y LONGITUD EN VARIABLES

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
    tpv_fecha_actual = fechaSemi;
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *fechaSemi2 = [NSString stringWithFormat:@"%@", [dateFormatter2 stringFromDate:[NSDate date]]];
    tpv_numero_orden = fechaSemi2;
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
    NSString *fechaSemi3 = [NSString stringWithFormat:@"%@", [dateFormatter3 stringFromDate:[NSDate date]]];
    tpv_fecha_ventas = fechaSemi3;
    
    NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *fechaSemi4 = [NSString stringWithFormat:@"%@", [dateFormatter4 stringFromDate:[NSDate date]]];
    tpv_fecha_hora_ventas = fechaSemi4;
    
    NSDateFormatter *dateFormatter5 = [[NSDateFormatter alloc] init];
    [dateFormatter5 setDateFormat:@"HH"];
    NSString *fechaSemi5 = [NSString stringWithFormat:@"%@", [dateFormatter5 stringFromDate:[NSDate date]]];
    tpv_hora_ventas = fechaSemi5;
    
}// END FECHA ACTUAL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER EMAIL DEL CLIENTE

- (void)traerDatosTransaccion{
    
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];

    // 1. PONER VALORES DUMMY
    tpv_numero_tarjeta = @"5152313099130713";
    tpv_cvv = @"937";
    tpv_fecha = @"01/20";
    
    [objeto_transaccion set_numero_tarjeta_transaccion:tpv_numero_tarjeta];
    [objeto_transaccion set_cvv_transaccion:tpv_cvv];
    [objeto_transaccion set_fecha_vencimiento_transaccion:tpv_fecha];
    
    tpv_monto = [NSString stringWithFormat:@"%@", [objeto_transaccion get_monto_transaccion]];
    tpv_tipo_pago = [NSString stringWithFormat:@"%@", [objeto_transaccion get_tipo_pago_transaccion]];
   
    tpv_correo_recibe = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    tpv_vendedor = [[NSUserDefaults standardUserDefaults] objectForKey:@"vendedor"];

    
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
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/transacciontarjeta.php?recibe=%@&monto=%@", tpv_correo_recibe, tpv_monto];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
        
        [self traerCarritoYInsertarVentas];
        [self agregarATransaccionesMYSQL];

        
    }else{
        
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
    
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/transacciones.php?fecha=%@&tipo=%@&monto=%@&numeroTarjeta=%@&emisor=%@&receptor=%@&concepto=%@&latitud=%@&longitud=%@", tpv_fecha_actual, tpv_tipo_pago, tpv_monto, tpv_numero_tarjeta, correo_paga_transaccion_tarjeta, tpv_correo_recibe, concepto, tpv_latitud, tpv_longitud];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
        // PONER FOTO DE SUCCESS EN LA PANTALLA
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(presentarPantallaSuccess) userInfo:nil repeats:NO];
        
    }else{
        
        // PONER FOTO DE FAIL EN LA PANTALLA
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentarPantallFail) userInfo:nil repeats:NO];
        
        
    }// END IF SUCCESS
    
    
}// END AGREGAR A TRANSACCIONES MYSQL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER CARRITO Y MANDAR INSERTAR EN VENTAS LOCAL

- (void)traerCarritoYInsertarVentas{
    
[self insertarVentas:@"TPV" :@"TPV" :tpv_monto :@"TPV"];
    
    
}// END INSERTAR CORREO TEMPORAL


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// FUNCION QUE INSERTA EN VENTAS LOCAL RECIBIENDO PARAMETROS

- (void)insertarVentas:(NSString *)nombre_producto :(NSString *)palabra_clave :(NSString *)precio :(NSString *)descripcion{
    
    // VARIABLES DE SQLITE
    sqlite3 *ventas;
    NSString *dbPathString;
    
    // RUTA SQLITE
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"ventas.db"];
    
    
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &ventas)==SQLITE_OK) {
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO VENTAS (NOMBREPRODUCTO, PALABRACLAVE, PRECIO, DESCRIPCION, FECHA, FECHAHORA, HORA, LATITUD, LONGITUD, TIPOPAGO, NUMEROTARJETA, NUMEROORDEN,VENDEDOR) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", nombre_producto, palabra_clave,precio,descripcion,tpv_fecha_ventas,tpv_fecha_hora_ventas, tpv_hora_ventas, tpv_latitud,tpv_longitud,tpv_tipo_pago,tpv_numero_tarjeta,tpv_numero_orden,tpv_vendedor];
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
    _imageView_animacion.image = [UIImage imageNamed:@"pantalla_fail_transaccion.png"];// ME EQUIVOQUE EN LOS NOMBRES DE LAS IMAGENES.. ESTAN INVERTIDAS
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
