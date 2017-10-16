//
//  Vendedor.h
//  Tapp
//
//  Created by Juancho Pestana on 6/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vendedor : NSObject{
    
    NSString *id_vendedor;
    NSString *nombre_vendedor;
    NSString *apellido_vendedor;
    NSString *nomina_vendedor;
}

-(void) set_id_vendedor:(NSString *) the_id_vendedor;

-(void) set_nombre_vendedor:(NSString *) the_nombre_vendedor;

-(void) set_apellido_vendedor:(NSString *) the_apellido_vendedor;

-(void) set_nomina_vendedor:(NSString *) the_nomina_vendedor;



-(NSString *)get_id_vendedor;

-(NSString *)get_nombre_vendedor;

-(NSString *)get_apellido_vendedor;

-(NSString *)get_nomina_vendedor;


@end
