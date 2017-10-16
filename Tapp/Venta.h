//
//  Venta.h
//  Tapp
//
//  Created by Juan Pestana on 9/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venta : NSObject{
    
    NSString *id_venta;
    NSString *nombre_producto_venta;
    NSString *palabra_clave_venta;
    NSString *precio_venta;
    NSString *fechahora_venta;
    NSString *tipopago_venta;
    NSString *vendedor_venta;
    NSString *cuenta_venta;


}

-(void) set_id_venta:(NSString *) the_id_venta;

-(void) set_nombre_producto_venta:(NSString *) the_nombre_producto_venta;

-(void) set_palabra_clave_venta:(NSString *) the_palabra_clave_venta;

-(void) set_precio_venta:(NSString *) the_precio_venta;

-(void) set_fechahora_venta:(NSString *) the_fechahora_venta;

-(void) set_tipopago_venta:(NSString *) the_tipopago_venta;

-(void) set_vendedor_venta:(NSString *) the_vendedor_venta;

-(void) set_cuenta_venta:(NSString *) the_cuenta_venta;



-(NSString *)get_id_venta;

-(NSString *)get_nombre_producto_venta;

-(NSString *)get_palabra_clave_venta;

-(NSString *)get_precio_venta;

-(NSString *)get_fechahora_venta;

-(NSString *)get_tipopago_venta;

-(NSString *)get_vendedor_venta;

-(NSString *)get_cuenta_venta;




@end
