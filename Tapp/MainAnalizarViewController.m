//
//  MainAnalizarViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 3/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "MainAnalizarViewController.h"

@interface MainAnalizarViewController ()

@end

@implementation MainAnalizarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. TRAER NOMBRE
    [self traerNombre];
    
    // 3. VERIFICAR INTERNET
    [self verificarInternet];
    
    // 4. PONER LOGO
    [self ponerLogoEnImagen];
    
    

}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE

// METODO QUE CONFIGURAR SWIPE
- (void)configurarSwipe{
    
    _swipe_regresar.numberOfTouchesRequired = 2;
    
}// END CONFIGURAR SWIPE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//
- (IBAction)accion_regresar:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];
}

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
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(crearAlertError) userInfo:nil repeats:NO];
        _label_monto_actual.text = @"0.00 MXN";
        
    }else{
        // SI HAY
        
        // 1. TRAER MONTO
        [self traerMontoMysql];
        
    }// END IF INTERNET
    
}// END VERIFICAR INTERNET


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER NOMBRE

- (void)traerNombre{
    
    NSString *nombreTraido = [[NSUserDefaults standardUserDefaults] objectForKey:@"nombre"];
    NSString *nombre_final;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    nombre_final = [[nombreTraido componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @" "];
    
    _label_nombre_usuario.text = nombre_final;

    NSString *prefixNombre = nil;
    
    if ([nombreTraido length] >= 1)
        prefixNombre = [nombreTraido substringToIndex:1];
    else
        prefixNombre = nombreTraido;
    
    NSString *iniciales = [NSString stringWithFormat:@"%@", prefixNombre];
    NSString *iniciales_final = [iniciales uppercaseString];
    _label_inicial.text = iniciales_final;

    
}// END TRAER NOMBRE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER MONTO

- (void)traerMontoMysql{
    
    NSString *email_usuario = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/ios/traerMonto.php?usuario=%@",  email_usuario];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strMonto = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    double montoPresentar = [strMonto doubleValue];
    
    NSString *montoSeminfinal = [NSString stringWithFormat:@"%0.2f", montoPresentar];
    
    double total_acumulado = [montoSeminfinal doubleValue];
    
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
        
        NSString *montosemi = [NSString stringWithFormat:@"%0.2f MXN", monto_i];
        _label_monto_actual.text = montosemi;
        
    }else if(diezmil == 0){
        NSString *monto = [NSString stringWithFormat:@"%d,%d%d%d.%d%d MXN", mil, centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin];
        _label_monto_actual.text = monto;
        
    }else if(centenar == 0){
        NSString *monto = [NSString stringWithFormat:@"%d%d,%d%d%d.%d%d MXN", diezmil, mil_fin, centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin];
        _label_monto_actual.text = monto;
    }else if(millon == 0){
        NSString *monto = [NSString stringWithFormat:@"%d%d%d,%d%d%d.%d%d MXN", centenar, diezmil_fin, mil_fin, centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin];
        _label_monto_actual.text = monto;
    }else{
        NSString *monto = [NSString stringWithFormat:@"%d,%d%d%d,%d%d%d.%d%d MXN", millon, cienmil_fin, diezmil_fin, mil_fin, centena_fin, decena_fin, unidad_fin, decima_fin, centesima_fin];
        _label_monto_actual.text = monto;
        
    }
    
}// END PONER COMAS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//ACCION PANTALLA QR CODE

- (IBAction)accion_pantalla_qr:(id)sender {
    
    [self performSegueWithIdentifier: @"qrcode" sender: self];

}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT TEXTFIELD EN BLANCO

- (void)crearAlertError{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"No hay conexión a internet."
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
    
}// END CREAR ALERTA USUARIO YA EXISTE


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PONE LOGO EN IMAGEVIEW

- (void)ponerLogoEnImagen{
    
    NSString *logo_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"logo"];

    NSString *nombreFoto = [NSString stringWithFormat:@"%@.png", logo_traido];
    _imagen_logo.image = [self loadImage: nombreFoto];
    
}

- (UIImage*)loadImage:(NSString*)imageName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    
    return [UIImage imageWithContentsOfFile:fullPath];
    
}// END LOAD IMAGE LOGO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PANTALLA ESTADISTICAS UNO

- (IBAction)accion_estadisticas_uno:(id)sender {

    [self performSegueWithIdentifier: @"estadisticas" sender: self];


}// END ACCION PANTALLA ESTADISTICAS UNO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PANTALLA HISTORIAL

- (IBAction)accion_pantalla_historial:(id)sender {
    
    [self performSegueWithIdentifier: @"historial" sender: self];

}
@end
