//
//  CreandoCuentaVC.m
//  Tapp
//
//  Created by Juancho Pestana on 2/26/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "CreandoCuentaVC.h"

@interface CreandoCuentaVC ()

@end

NSString *correo_creando_cuenta;
NSString *nip_creando_cuenta;
NSString *fecha_creando_cuenta;

BOOL check_mysql;
BOOL check_userDefaults;
BOOL check_phpemail;

@implementation CreandoCuentaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. INICIALIZAR INDICADOR
    [self.activity_indicator startAnimating];

    // 1. TRAER NIP Y CORREO
    [self traerNipYCorreo];
    
    // 2. INICIALIZAR BOOLS
    [self inicializarBools];
    
    // 3. VERIFICAR CONEXION INTERNET
    [self verificarInternet];
    
    

}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER NIP Y CORREO

- (void)traerNipYCorreo{
    
    Registro *objeto_registro = [Registro registroGlobal];
    correo_creando_cuenta = [NSString stringWithFormat:@"%@", [objeto_registro getCorreo]];
    nip_creando_cuenta = [NSString stringWithFormat:@"%@", [objeto_registro getNip]];

//    NSLog(@"%@ , %@", correo_creando_cuenta, nip_creando_cuenta);
    
    
}// END TRAER NIP Y CORREO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE INICIALIZA BOOLS DE VERIFICACION EN FALSO
- (void)inicializarBools{
    
    check_userDefaults = false;
    check_mysql = false;
    check_phpemail = false;
    
}// END INICIALIZAR BOOLS

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
    fecha_creando_cuenta = fechaSemi;
    
}// END FECHA ACTUAL

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
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moverAPantallaWifi) userInfo:nil repeats:NO];
        
        
    }else{
        // SI HAY
        // A. INSERTAR USUARIO SI ES QUE NO ESTA REPETIDO, SI NO, MOSTRAR PANTALLA REPETIDO
        [self insertarMYSQLSiNoEstaRepetido];
        
        
    }// END IF INTERNET
    
}// END VERIFICAR INTERNET

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

// METODO QUE INSERTA USUARIO Y CONTRASENA EN MYSQL
- (void)insertarMYSQLSiNoEstaRepetido{
    
    // TRAER FECHA ACTUAL
    [self traerFechaActual];
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/usuario.php?usuario=%@&nip=%@&fecha=%@", correo_creando_cuenta, nip_creando_cuenta, fecha_creando_cuenta];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
        // USUARIO DISPONIBLE, INSERTAR EN MYSQL
        check_mysql = true;
        [self userDefaultsUsuarioYNip];
        
    }else{
        
        // USUARIO ESTA OCUPADO, PRESENTAR ALERTA USUARIO OCUPADO
         [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moverAPantallaOcupado) userInfo:nil repeats:NO];
    
    }// END IF USUARIO OCUPADO
    
    
}// END INSERTAR MYSQL USUARIO CONTRASENA

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE CREA NSUSERDEFAULTS CON USUARIO Y CONTRASENA

- (void)userDefaultsUsuarioYNip{
    
    // USERNAME
    [[NSUserDefaults standardUserDefaults] setObject:correo_creando_cuenta forKey:@"correo_usuario"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // NIP
    [[NSUserDefaults standardUserDefaults] setObject:nip_creando_cuenta forKey:@"nip_usuario"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    check_userDefaults = true;
    
    [self emailPHPActivarCuenta];
    
}// END INSERTAR USUARIO Y NIP NSUSERDEFAULTS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE

// METODO QUE MANDA UN EMAIL AL NUEVO USUARIO CON LINK ACTIVACION
- (void)emailPHPActivarCuenta{
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/mail/prueba.php?email=%@", correo_creando_cuenta];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
        check_phpemail = true;
        [self crearTodoTapp];
    }else{
        
        [self borrarUsuarioMalCreado];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moverAPantallaError) userInfo:nil repeats:NO];
        
        
    }
    
}// END PHP EMAIL USUARIO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE BORRA USUARIO DE MYSQL PORQUE NO SE MANDO BIEN EL MAIL

- (void)borrarUsuarioMalCreado{
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/mail/deleteUser.php?email=%@", correo_creando_cuenta];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
      // ESTE IF SOLO LO TENGO PORQUE SI NO ME MARCA WARNING DE QUE NO USO
        // LA DE STRRESULT Y LA NECESITO A FUERZAS
    }
    
}// END BORRAR USUARIO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE MUEVE A PANTALLA DE ERROR DE WIFI

// METODO QUE PRESENTA VIEW CONTROLLER WIFI
- (void)moverAPantallaWifi{
    
    [self performSegueWithIdentifier: @"wifi" sender: self];
    
}// END VIEW CONTROLLER WIFI


// METODO QUE PRESENTA VIEW CONTROLLER ERROR NORMAL
- (void)moverAPantallaError{
    
    [self performSegueWithIdentifier: @"error" sender: self];
    
}// END VIEW CONTROLLER WIFI


// METODO QUE PRESENTA VIEW CONTROLLER ERROR CORREO OCUPADO
- (void)moverAPantallaOcupado{
    
    [self performSegueWithIdentifier: @"ocupado" sender: self];
    
}// END VIEW CONTROLLER ERROR CORREO OCUPADO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE MUEVE PANTALLA

// SWIPE FORWARD
- (void)swipe_left{
    
    [self performSegueWithIdentifier: @"left" sender: self];
    
}// END ACCION FORWARD



#pragma mark

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// METODO CREAR BASE SQLITE PRODUCTOS
- (void)crearDBProductos{
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"productos.db"];
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        if (sqlite3_open(dbPath, &productos)==SQLITE_OK) {
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS PRODUCTOS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NOMBRE TEXT, PALABRACLAVE TEXT, PRECIO TEXT, DESCRIPCION TEXT, NOMBREIMAGEN TEXT, CATEGORIA TEXT)";
            sqlite3_exec(productos, sql_stmt, NULL, NULL, &error);
            sqlite3_close(productos);
            
            NSLog(@"TABLA PRODUCTOS CREADA");
        }
    }
    
}// END CREATE SQLITE PRODUCTOS

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// METODO CREAR BASE SQLITE CATEGORIAS
- (void)crearDBCategorias{
    
    // VARIABLES DE SQLITE
    sqlite3 *categorias;
    NSString *dbPathString;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"categorias.db"];
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        if (sqlite3_open(dbPath, &categorias)==SQLITE_OK) {
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CATEGORIAS (ID INTEGER PRIMARY KEY AUTOINCREMENT, CATEGORIA TEXT, NOMBREIMAGEN TEXT)";
            sqlite3_exec(categorias, sql_stmt, NULL, NULL, &error);
            sqlite3_close(categorias);
            
            NSLog(@"TABLA CATEGORIAS CREADA");
        }
    }
    
}// END CREATE SQLITE CATEGORIAS

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// METODO CREAR BASE SQLITE CARRITO
- (void)crearDBCarrito{
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"carrito.db"];
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        if (sqlite3_open(dbPath, &productos)==SQLITE_OK) {
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CARRITO (ID INTEGER PRIMARY KEY AUTOINCREMENT, NOMBRE TEXT, PALABRACLAVE TEXT, PRECIO TEXT, DESCRIPCION TEXT, NOMBREIMAGEN TEXT, STATE TEXT)";
            sqlite3_exec(productos, sql_stmt, NULL, NULL, &error);
            sqlite3_close(productos);
            
            NSLog(@"TABLA CARRITO CREADA");
        }
    }
    
}// END CREATE SQLITE CARRITO

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// METODO CREAR BASE SQLITE VENTAS
- (void)crearDBVentas{
    
    
    // VARIABLES DE SQLITE
    sqlite3 *ventas;
    NSString *dbPathString;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"ventas.db"];
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        if (sqlite3_open(dbPath, &ventas)==SQLITE_OK) {
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS VENTAS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NOMBREPRODUCTO TEXT, PALABRACLAVE TEXT, PRECIO TEXT, DESCRIPCION TEXT, FECHA TEXT, FECHAHORA TEXT, HORA TEXT, LATITUD TEXT, LONGITUD TEXT, TIPOPAGO TEXT, NUMEROTARJETA TEXT, NUMEROORDEN TEXT, VENDEDOR TEXT)";
            sqlite3_exec(ventas, sql_stmt, NULL, NULL, &error);
            sqlite3_close(ventas);
            
            NSLog(@"TABLA VENTAS CREADA");
        }
    }
    
}// END CREATE SQLITE VENTAS

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// METODO CREAR BASE SQLITE VENDEDORES
- (void)crearDBVendedores{
    
    // VARIABLES DE SQLITE
    sqlite3 *vendedores;
    NSString *dbPathString;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"vendedores.db"];
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        if (sqlite3_open(dbPath, &vendedores)==SQLITE_OK) {
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS VENDEDORES (ID INTEGER PRIMARY KEY AUTOINCREMENT, NOMBRE TEXT, APELLIDO TEXT, NOMINA TEXT)";
            sqlite3_exec(vendedores, sql_stmt, NULL, NULL, &error);
            sqlite3_close(vendedores);
            
            NSLog(@"TABLA VENDEDORES CREADA");
        }
    }
    
}// END CREATE SQLITE VENDEDORES

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// INSERTAR EN CATEGORIA

- (void)insertarCategoria{
    
    // VARIABLES DE SQLITE
    sqlite3 *categorias;
    NSString *dbPathString;
    
    NSString *string_nombre = @"Todos";
    NSString *string_nombre_imagen = @"categoriatodos.png";
    
    // RUTA SQLITE
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"categorias.db"];
    
    
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &categorias)==SQLITE_OK) {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO CATEGORIAS (CATEGORIA, NOMBREIMAGEN) values ('%@','%@')",
                                string_nombre, string_nombre_imagen];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(categorias, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            
            
        }
        sqlite3_close(categorias);
    }
    
}// END INSERTAR CATEGORIAS

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// GUARDAR IMAGEN CATEGORIA TODOS (LA QUE TIENE EL LOGO DE TAPP)

- (void)guardarImagenTodos{
    
    UIImage *image = [UIImage imageNamed:@"categoriatodos.png"];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"categoriatodos.png"]];
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
}



- (void)crearTodoTapp{
    
    // 1. CREAR BASE SQLITE PRODUCTOS
    [self crearDBProductos];
    
    // 2. CREAR BASE SQLITE CATEGORIAS
    [self crearDBCategorias];
    
    // 3. INSERTAR EL PRIMER RENGLON DE TABLA CATEGORIAS
    [self insertarCategoria];
    
    // 4. GUARDAR IMAGEN CATEGORIA GENERAL EN DOCUMENTS FOLDER
    [self guardarImagenTodos];
    
    // 5. CREAR BASE SQLITE CATEGORIAS
    [self crearDBCarrito];
    
    // 6. CREAR BASE SQLITE VENTAS
    [self crearDBVentas];
    
    // 7. CREAR BASE SQLITE VENDEDORES
    [self crearDBVendedores];
    
    // 8. CREAR NSUSERDEFAULTS DE SETTINGS
    [[NSUserDefaults standardUserDefaults] setObject:@"Nombre" forKey:@"nombre"];
    [[NSUserDefaults standardUserDefaults] setObject:@"# Cuenta" forKey:@"numero_cuenta"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Clabe" forKey:@"clabe"];
    [[NSUserDefaults standardUserDefaults] setObject:@"tienda" forKey:@"modo"];
    [[NSUserDefaults standardUserDefaults] setObject:@"VendedorTapp" forKey:@"vendedor"];
    [[NSUserDefaults standardUserDefaults] setObject:@"VendedorTapp" forKey:@"vendedor_nombre"];
    [[NSUserDefaults standardUserDefaults] setObject:@"VendedorTapp" forKey:@"vendedor_apellido"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"logoTapp" forKey:@"logo"];
    [[NSUserDefaults standardUserDefaults] setObject:@"firmaTapp" forKey:@"firma"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"r1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"g1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"b1"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"r2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"g2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"b2"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"r3"];
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"g3"];
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"b3"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"letras_r"];
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"letras_g"];
    [[NSUserDefaults standardUserDefaults] setObject:@"255" forKey:@"letras_b"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"fechaTappInferior" forKey:@"fecha_inferior"];
    [[NSUserDefaults standardUserDefaults] setObject:@"fechaTappSuperior" forKey:@"fecha_superior"];

    
    
    // 9. NSUSERDEFAULTS CAMBIAR STATUS
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"primera"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(swipe_left) userInfo:nil repeats:NO];


}// END CREAR TODO TAPP




@end
