//
//  ClabeViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "ClabeViewController.h"

@interface ClabeViewController ()

@end

@implementation ClabeViewController

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
    
    NSString *clabe_escrito = self.textfield_clabe.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:clabe_escrito forKey:@"clabe"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

}

- (IBAction)iphone_accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END IPHONE ACCION SWIPE RIGHT

- (IBAction)iphone_accion_swipe_left:(id)sender {
    
    NSString *clabe_escrito = self.textfield_clabe.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:clabe_escrito forKey:@"clabe"];
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
    
    NSString *clabe_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"clabe"];
    [_textfield_clabe becomeFirstResponder];
    _textfield_clabe.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    
    [_textfield_clabe setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_clabe setBorderStyle:UITextBorderStyleNone]; //clear borders
    _textfield_clabe.keyboardAppearance = UIKeyboardAppearanceAlert;
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:clabe_traido attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_clabe.attributedPlaceholder = str1;
    _textfield_clabe.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_clabe.tag = 1;
    _textfield_clabe.delegate = self;
    
    
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
