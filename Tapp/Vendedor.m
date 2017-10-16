//
//  Vendedor.m
//  Tapp
//
//  Created by Juancho Pestana on 6/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "Vendedor.h"

@implementation Vendedor

// SETTERS

-(void) set_id_vendedor:(NSString *)the_id_vendedor{
    
    id_vendedor = the_id_vendedor;
}

-(void) set_nombre_vendedor:(NSString *)the_nombre_vendedor{
    
    nombre_vendedor = the_nombre_vendedor;
}

-(void) set_apellido_vendedor:(NSString *)the_apellido_vendedor{
    
    apellido_vendedor = the_apellido_vendedor;
}

-(void) set_nomina_vendedor:(NSString *)the_nomina_vendedor{
    
    nomina_vendedor = the_nomina_vendedor;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GETTERS
- (NSString *)get_id_vendedor{
    return id_vendedor;
}

- (NSString *)get_nombre_vendedor{
    return nombre_vendedor;
}

- (NSString *)get_apellido_vendedor{
    return apellido_vendedor;
}

- (NSString *)get_nomina_vendedor{
    return nomina_vendedor;
}



@end
