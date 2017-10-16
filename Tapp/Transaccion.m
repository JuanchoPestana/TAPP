//
//  Transaccion.m
//  Tapp
//
//  Created by Juancho Pestana on 4/12/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "Transaccion.h"

@implementation Transaccion

// SETTERS

-(void) set_id_transaccion:(NSString *)the_id_transaccion{
    
    id_transaccion = the_id_transaccion;
}

-(void) set_monto_transaccion:(NSString *)the_monto_transaccion{
    
    monto_transaccion = the_monto_transaccion;
}

-(void) set_numero_tarjeta_transaccion:(NSString *)the_numero_tarjeta_transaccion{
    
    numero_tarjeta_transaccion = the_numero_tarjeta_transaccion;
}

-(void) set_cvv_transaccion:(NSString *)the_cvv_transaccion{
    
    cvv_transaccion = the_cvv_transaccion;
}

-(void) set_fecha_vencimiento_transaccion:(NSString *)the_fecha_vencimiento_transaccion{
    
    fecha_vencimiento_transaccion = the_fecha_vencimiento_transaccion;
}


-(void) set_fecha_transaccion:(NSString *)the_fecha_transaccion{
    
    fecha_transaccion = the_fecha_transaccion;
}

-(void) set_latitud_transaccion:(NSString *)the_latitud_transaccion{
    
    latitud_transaccion = the_latitud_transaccion;
}

-(void) set_longitud_transaccion:(NSString *)the_longitud_transaccion{
    
    longitud_transaccion = the_longitud_transaccion;
}

-(void) set_numero_orden_transaccion:(NSString *)the_numero_orden_transaccion{
    
    numero_orden_transaccion = the_numero_orden_transaccion;
}

-(void) set_tipo_pago_transaccion:(NSString *)the_tipo_pago_transaccion{
    
    tipo_pago_transaccion = the_tipo_pago_transaccion;
}

-(void) set_mail_qrcode_transaccion:(NSString *)the_mail_qrcode_transaccion{
    
    mail_qrcode_transaccion = the_mail_qrcode_transaccion;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GETTERS

- (NSString *)get_id_transaccion{
    return id_transaccion;
}

- (NSString *)get_monto_transaccion{
    return monto_transaccion;
}

- (NSString *)get_numero_tarjeta_transaccion{
    return numero_tarjeta_transaccion;
}

- (NSString *)get_cvv_transaccion{
    return cvv_transaccion;
}

- (NSString *)get_fecha_vencimiento_transaccion{
    return fecha_vencimiento_transaccion;
}

- (NSString *)get_fecha_transaccion{
    return fecha_transaccion;
}

- (NSString *)get_latitud_transaccion{
    return latitud_transaccion;
}

- (NSString *)get_longitud_transaccion{
    return longitud_transaccion;
}

- (NSString *)get_numero_orden_transaccion{
    return numero_orden_transaccion;
}

- (NSString *)get_tipo_pago_transaccion{
    return tipo_pago_transaccion;
}

- (NSString *)get_mail_qrcode_transaccion{
    return mail_qrcode_transaccion;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// REGISTRO GLOBAL

+ (id)transaccionGlobal {
    
    static Transaccion *transaccion_global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transaccion_global = [[self alloc] init];
    });
    return transaccion_global;
}


@end
