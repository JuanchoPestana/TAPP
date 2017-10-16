//
//  NombreViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/22/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "NombreViewController.h"

@interface NombreViewController ()

@end

@implementation NombreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. PONER NOMBRE ACTUAL COMO PLACEHOLDER
    [self nombreActualPlaceholder];
  

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


- (IBAction)accion_swipe_right:(id)sender {
    [self performSegueWithIdentifier: @"regresar" sender: self];
}

- (IBAction)accion_swipe_left:(id)sender {
    
    
    NSString *nombre_escrito = self.textfield_nombre.text;
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    nombre_escrito = [[nombre_escrito componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];

    
    [[NSUserDefaults standardUserDefaults] setObject:nombre_escrito forKey:@"nombre"];
    [[NSUserDefaults standardUserDefaults] synchronize];
 

    [self performSegueWithIdentifier: @"continuar" sender: self];
}

- (IBAction)iphone_accion_swipe_right:(id)sender {

    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END IPHONE ACCION SWIPE RIGHT

- (IBAction)iphone_accion_swipe_left:(id)sender {
    
    NSString *nombre_escrito = self.textfield_nombre.text;
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@" "];
    nombre_escrito = [[nombre_escrito componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:nombre_escrito forKey:@"nombre"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self performSegueWithIdentifier: @"continuar" sender: self];
    
}// END IPHONE ACCION SWIPE LEFT


//NSString *nombre_escrito = self.textfield_nombre.text;
//NSLog(@" nombre escrito: %@", nombre_escrito);
//
//[[NSUserDefaults standardUserDefaults] setObject:nombre_escrito forKey:@"nombre"];
//[[NSUserDefaults standardUserDefaults] synchronize];
//
//
//[self performSegueWithIdentifier: @"continuar" sender: self];

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PONER NOMBRE ACTUAL COMO PLACEHOLDER

- (void)nombreActualPlaceholder{
    
    NSString *nombreTraido = [[NSUserDefaults standardUserDefaults] objectForKey:@"nombre"];
    NSString *nombre_semifinal;
    NSString *nombre_final;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    nombre_semifinal = [[nombreTraido componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @" "];
    nombre_final = [nombre_semifinal uppercaseString];

    _textfield_nombre.delegate = self;
    _textfield_nombre.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _textfield_nombre.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    [_textfield_nombre setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_nombre setBorderStyle:UITextBorderStyleNone]; //clear borders
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:nombre_final attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_nombre.attributedPlaceholder = str1;
    _textfield_nombre.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_nombre.tag = 1;
    [_textfield_nombre becomeFirstResponder];

}// END NOMBRE ACTUAL PLACEHOLDER

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



@end
