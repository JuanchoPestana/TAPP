//
//  Transaccion.h
//  Tapp
//
//  Created by Juancho Pestana on 4/12/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaccion : NSObject{
    
    NSString *id_transaccion;
    NSString *monto_transaccion;
    NSString *numero_tarjeta_transaccion;
    NSString *cvv_transaccion;
    NSString *fecha_vencimiento_transaccion;
    
    NSString *fecha_transaccion;
    NSString *latitud_transaccion;
    NSString *longitud_transaccion;
    NSString *numero_orden_transaccion;
    NSString *tipo_pago_transaccion;
    
    NSString *mail_qrcode_transaccion;

  
    
}

-(void) set_id_transaccion:(NSString *) the_id_transaccion;
-(void) set_monto_transaccion:(NSString *) the_monto_transaccion;
-(void) set_numero_tarjeta_transaccion:(NSString *) the_numero_tarjeta_transaccion;
-(void) set_cvv_transaccion:(NSString *) the_cvv_transaccion;
-(void) set_fecha_vencimiento_transaccion:(NSString *) the_fecha_vencimiento_transaccion;

-(void) set_fecha_transaccion:(NSString *) the_fecha_transaccion;
-(void) set_latitud_transaccion:(NSString *) the_latitud_transaccion;
-(void) set_longitud_transaccion:(NSString *) the_longitud_transaccion;
-(void) set_numero_orden_transaccion:(NSString *) the_numero_orden_transaccion;
-(void) set_tipo_pago_transaccion:(NSString *) the_tipo_pago_transaccion;

-(void) set_mail_qrcode_transaccion:(NSString *) the_mail_qrcode_transaccion;



-(NSString *)get_id_transaccion;
-(NSString *)get_monto_transaccion;
-(NSString *)get_numero_tarjeta_transaccion;
-(NSString *)get_cvv_transaccion;
-(NSString *)get_fecha_vencimiento_transaccion;

-(NSString *)get_fecha_transaccion;
-(NSString *)get_latitud_transaccion;
-(NSString *)get_longitud_transaccion;
-(NSString *)get_numero_orden_transaccion;
-(NSString *)get_tipo_pago_transaccion;

-(NSString *)get_mail_qrcode_transaccion;



+ (Transaccion *)transaccionGlobal;

@end
