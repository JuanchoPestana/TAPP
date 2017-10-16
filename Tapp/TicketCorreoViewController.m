//
//  TicketCorreoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "TicketCorreoViewController.h"

@interface TicketCorreoViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString_productos;
    

}// END INTERFACE


@end

// ESTE ID_NUM ES PARA EL METODO DE UPDATE STATE
NSString *id_num;
// ESTE BOOL ES PARA VER SI HAY DATOS CON STATE "PENDING" O NO
bool entrar;

NSString *ticket_tienda_fecha;

@implementation TicketCorreoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. CONFIGURAR CORREO
    [self configurarTextfieldCorreo];
    
    // 3. TRAER FECHA ACTUAL
    [self traerFechaActual];


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

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// CONFIGURAR TEXTFIELD

- (void)configurarTextfieldCorreo{
    
    _textfield_correo.delegate = self;
    self.textfield_correo.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfield_correo.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    [_textfield_correo setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_correo setBorderStyle:UITextBorderStyleNone]; //clear borders
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Correo electrónico" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_correo.attributedPlaceholder = str1;
    _textfield_correo.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_correo.tag = 1;
    [_textfield_correo becomeFirstResponder];
    
    
}// END CONFIGURAR TEXTFIELD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// BLOQUAR COPY PASTE ASSIST
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    UITextInputAssistantItem* item = [textField inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE RIGHT
- (IBAction)accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END ACCION SWIPE RIGHT

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION CONTINUAR

- (IBAction)accion_swipe_left:(id)sender {
    
    // REVISAR SI HAY INTERNET, SI NO, MANDAR ALERT
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        // NO HAY
        [self crearAlertWIFI];
        
    }else{
        // SI HAY
        [self enviarCorreo];
        
    }// END IF INTERNET
    
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO ENVIAR CORREO

- (void)successCorreo{
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}// END ENVIAR CORREO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE MANDA EL CORREO DEL TICKET
-(void)enviarCorreo{
    
    [self insertarMysqlCarrito];
    
    Transaccion *objeto_transaccion = [Transaccion transaccionGlobal];
    
    
    NSString *numero_tarjeta_actual = [NSString stringWithFormat:@"%@", [objeto_transaccion get_numero_tarjeta_transaccion]];
    NSString *monto_actual = [NSString stringWithFormat:@"%@", [objeto_transaccion get_monto_transaccion]];
    NSString *nombre_usuario = [[NSUserDefaults standardUserDefaults] objectForKey:@"nombre"];
    NSString *apellido_usuario = @"";
    NSString *fecha = ticket_tienda_fecha;
    NSString *email_recibe = _textfield_correo.text;
    NSString *resultado_email;
    NSString *firma = [[NSUserDefaults standardUserDefaults] objectForKey:@"firma"];
    
    NSString *string_tienda = @"tienda";
    
    NSString *nombre_logo = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];
    NSString *r1= [[NSUserDefaults standardUserDefaults] objectForKey:@"r1"];
    NSString *g1= [[NSUserDefaults standardUserDefaults] objectForKey:@"g1"];
    NSString *b1= [[NSUserDefaults standardUserDefaults] objectForKey:@"b1"];
    NSString *r2= [[NSUserDefaults standardUserDefaults] objectForKey:@"r2"];
    NSString *g2= [[NSUserDefaults standardUserDefaults] objectForKey:@"g2"];
    NSString *b2= [[NSUserDefaults standardUserDefaults] objectForKey:@"b2"];
    NSString *r3= [[NSUserDefaults standardUserDefaults] objectForKey:@"r3"];
    NSString *g3= [[NSUserDefaults standardUserDefaults] objectForKey:@"g3"];
    NSString *b3= [[NSUserDefaults standardUserDefaults] objectForKey:@"b3"];
    NSString *rl= [[NSUserDefaults standardUserDefaults] objectForKey:@"letras_r"];
    NSString *gl= [[NSUserDefaults standardUserDefaults] objectForKey:@"letras_g"];
    NSString *bl= [[NSUserDefaults standardUserDefaults] objectForKey:@"letras_b"];
   
    
    NSString *primeraTarjeta = [numero_tarjeta_actual substringToIndex:1];
    
    
    NSString *tarjeta = [numero_tarjeta_actual substringFromIndex: [numero_tarjeta_actual length] - 4];
    
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/mail/ticketMailer.php?tarjeta=%@&primera=%@&monto=%@&nombre=%@&apellido=%@&fecha=%@&email=%@&nombreLogo=%@&r1=%@&g1=%@&b1=%@&r2=%@&g2=%@&b2=%@&r3=%@&g3=%@&b3=%@&rl=%@&gl=%@&bl=%@&modo=%@&firma=%@", tarjeta, primeraTarjeta, monto_actual, nombre_usuario, apellido_usuario, fecha, email_recibe, nombre_logo, r1, g1, b1, r2, g2, b2, r3, g3, b3, rl, gl, bl, string_tienda, firma];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    resultado_email = strResult;
    
    [self insertarEnCompradores];
    [self successCorreo];
 
    
}// END MANDAR CORREO TICKET

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION GMAIL

- (IBAction)accion_gmail:(id)sender {

    NSString *str1 = _textfield_correo.text;
    _textfield_correo.text = [str1  stringByAppendingString:@"@gmail.com"];

}// END ACCION GMAIL

- (IBAction)accion_hotmail:(id)sender {

    NSString *str1 = _textfield_correo.text;
    _textfield_correo.text = [str1  stringByAppendingString:@"@hotmail.com"];

}// END ACCION HOTMAIL

- (IBAction)accion_icloud:(id)sender {

    NSString *str1 = _textfield_correo.text;
    _textfield_correo.text = [str1  stringByAppendingString:@"@icloud.com"];

}// END ACCION ICLOUD

- (IBAction)accion_outlook:(id)sender {

    NSString *str1 = _textfield_correo.text;
    _textfield_correo.text = [str1  stringByAppendingString:@"@outlook.com"];

}// END ACCION OUTLOOK

- (IBAction)accion_yahoo:(id)sender {

    NSString *str1 = _textfield_correo.text;
    _textfield_correo.text = [str1  stringByAppendingString:@"@yahoo.com"];

}// END ACCION YAHOO

- (IBAction)accion_com:(id)sender {

    NSString *str1 = _textfield_correo.text;
    _textfield_correo.text = [str1  stringByAppendingString:@".com"];

}// END ACCION .COM

- (IBAction)accion_commx:(id)sender {

    NSString *str1 = _textfield_correo.text;
    _textfield_correo.text = [str1  stringByAppendingString:@".com.mx"];

}// END ACCION COM.MX

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// INSERTAR MYSQL CARRITO

- (void)insertarMysqlCarrito{
    
    NSString *nombre;
    NSString *precio;
    
    do{
        // 1. PREPARAR VARIABLES PARA SQLITE
        NSMutableString* result = [NSMutableString stringWithCapacity:50000];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [path objectAtIndex:0];
        NSString *path_con_nombre_variable = [NSString stringWithFormat:@"carrito.db"];
        dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
        sqlite3_stmt *statement;
        
        
        // 2. AGARRAR LOS PRIMEROS 20 RENGLONES DEL CARRITO Y PONERLOS EN EL STRING "RESULT" PARA ENVIAR HTTP
        if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
            
            NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CARRITO WHERE STATE = \"PENDING\" LIMIT 20"];
            const char* query_sql = [querySql UTF8String];
            
            if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
                int ic = 1;
                
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    NSString *id_number = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    id_num = id_number;
                    
                    nombre = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    precio = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    
                    [result appendFormat:@"nombre%d=%@&precio%d=%@&",ic, nombre, ic, precio];
                    
                    ic++;
                }
                
            }// END PREPARE
        }// END SQLITE OPEN
        sqlite3_close(productos);
        
        
        // CAMBIAR BOOL A ON SI HAY DATOS
        
        entrar = false;
        
        if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
            
            NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CARRITO WHERE STATE = \"PENDING\""];
            const char* query_sql = [querySql UTF8String];
            
            if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    entrar = true;// SIGNIFICA QUE TODAVIA QUEDAN PENDINGS
                }
            }
            sqlite3_close(productos);
        }
        
        // UPDATE EL STATE DEL SQLITE
        
        if (entrar == true) {//3
            
            // EMPIEZA ENVIAR DATOS A MYSQL
            
          
            NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/batchTapp.php?%@", result];
            
            
            NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
            NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
            NSLog(@"STRING RESULT: %@", strResult);
            
            if ([strResult isEqualToString:@"success"]) {
                
                int id_int = [id_num intValue];
                
                
                char *error;
                NSString *sent = @"SENT";
                if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
                    NSString *insertStmt = [NSString stringWithFormat:@"UPDATE CARRITO SET STATE = \"%@\" WHERE ID <= %d", sent, id_int];
                    const char *insert_stmt = [insertStmt UTF8String];
                    if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
                        
                        //      NSLog(@"BASE %@ STATE UPDATEADO", nombre_proyecto_actual_conexion);
                        
                    }
                    sqlite3_close(productos);
                }
                
            }// END IF (SE ENVIARON DATOS)
            
            
            
        }//3 END IF ENTRAR
        else {
            
            //                                           [self crearAlertaDatosSync];
            
        }
        
    }// END DO
    while (entrar == true);
    
    [self deleteCarrito];
    
}// END INSERTAR MYSQL CARRITO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// BORRAR TODO DEL CARRITO

- (void)deleteCarrito{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"carrito.db"];
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    
    char *error;
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        NSString *insertStmt = [NSString stringWithFormat:@"DELETE FROM CARRITO"];
        const char *insert_stmt = [insertStmt UTF8String];
        if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            
        }
        sqlite3_close(productos);
    }
    
}// END DELETE CARRITO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE AGARRA FECHA ACTUAL
- (void)traerFechaActual{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *fechaSemi = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    ticket_tienda_fecha = fechaSemi;
    
}// END FECHA ACTUAL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT WIFI

- (void)crearAlertWIFI{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"No hay conexion a internet."
                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    // BOTON CANCELAR
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    [alertTextfieldBlanco addAction:cancelAction];
    
    [self presentViewController:alertTextfieldBlanco animated:YES completion:nil];
    
}// END CREAR ALERTA WIFI

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// INSERTAR EN COMPRADORES

- (void)insertarEnCompradores{
    
    NSString *correo = _textfield_correo.text;
    NSString *tienda = [[NSUserDefaults standardUserDefaults] objectForKey:@"nombre"];

    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/compradores.php?usuario=%@&tienda=%@", correo, tienda];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strResult);
    
    
}// END INSERTAR EN COMPRADORES


@end
