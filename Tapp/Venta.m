//
//  Venta.m
//  Tapp
//
//  Created by Juan Pestana on 9/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "Venta.h"

@implementation Venta

// SETTERS

-(void) set_id_venta:(NSString *)the_id_venta{
    
    id_venta = the_id_venta;
}

-(void) set_nombre_producto_venta:(NSString *)the_nombre_producto_venta{
    
    nombre_producto_venta = the_nombre_producto_venta;
}

-(void) set_palabra_clave_venta:(NSString *)the_palabra_clave_venta{
    
    palabra_clave_venta = the_palabra_clave_venta;
}

-(void) set_precio_venta:(NSString *)the_precio_venta{
    
    precio_venta = the_precio_venta;
}

-(void) set_fechahora_venta:(NSString *)the_fechahora_venta{
    
    fechahora_venta = the_fechahora_venta;
}

-(void) set_tipopago_venta:(NSString *)the_tipopago_venta{
    
    tipopago_venta = the_tipopago_venta;
}

-(void) set_vendedor_venta:(NSString *)the_vendedor_venta{
    
    vendedor_venta = the_vendedor_venta;
}

-(void) set_cuenta_venta:(NSString *)the_cuenta_venta{
    
    cuenta_venta = the_cuenta_venta;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GETTERS

- (NSString *)get_id_venta{
    return id_venta;
}

- (NSString *)get_nombre_producto_venta{
    return nombre_producto_venta;
}

- (NSString *)get_palabra_clave_venta{
    return palabra_clave_venta;
}

- (NSString *)get_precio_venta{
    return precio_venta;
}

- (NSString *)get_fechahora_venta{
    return fechahora_venta;
}

- (NSString *)get_tipopago_venta{
    return tipopago_venta;
}

- (NSString *)get_vendedor_venta{
    return vendedor_venta;
}

- (NSString *)get_cuenta_venta{
    return cuenta_venta;
}

@end
