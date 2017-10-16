//
//  CuentaViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "CuentaViewController.h"

@interface CuentaViewController ()

@end

@implementation CuentaViewController

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
    
}// END ACCION SWIPE RIGHT

- (IBAction)accion_swipe_left:(id)sender {
    
    NSString *cuenta_escrito = self.textfield_numero_cuenta.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:cuenta_escrito forKey:@"numero_cuenta"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}

- (IBAction)iphone_accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END IPHONE SWIPE RIGHT

// ACCION IPHONE SWIPE LEFT
- (IBAction)iphone_accion_swipe_left:(id)sender {
    
    NSString *cuenta_escrito = self.textfield_numero_cuenta.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:cuenta_escrito forKey:@"numero_cuenta"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}// END IPHONE ACCION SWIPE LEFT

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PONER NOMBRE ACTUAL COMO PLACEHOLDER

- (void)nombreActualPlaceholder{
    
    NSString *cuenta_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"numero_cuenta"];
        [_textfield_numero_cuenta becomeFirstResponder];
    _textfield_numero_cuenta.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    
    [_textfield_numero_cuenta setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_numero_cuenta setBorderStyle:UITextBorderStyleNone]; //clear borders
    _textfield_numero_cuenta.keyboardAppearance = UIKeyboardAppearanceAlert;
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:cuenta_traido attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_numero_cuenta.attributedPlaceholder = str1;
    _textfield_numero_cuenta.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_numero_cuenta.tag = 1;
    _textfield_numero_cuenta.delegate = self;
    
    
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

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//

@end
