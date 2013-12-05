//
//  MBDInputViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/4/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBDInputViewController.h"

#import "MBDMapViewController.h"
#import "MBDProjectViewController.h"

@interface MBDInputViewController () <UITextFieldDelegate>

@property (nonatomic) MBDInputMode inputMode;
@property (nonatomic) IBOutlet UILabel *inputLabel;
@property (nonatomic) IBOutlet UITextField *inputField;

@end

@implementation MBDInputViewController

- (id)initWithInputMode:(MBDInputMode)mode
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
        _inputMode = mode;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    switch (self.inputMode)
    {
        case MBDInputModeMapID:
            self.title = @"Map ID";
            self.inputLabel.text = @"e.g. examples.greatmap";
            break;
        case MBDInputModeTileMill1:
            self.title = @"TileMill 1";
            self.inputLabel.text = @"e.g. 10.0.1.7 or Joe.local";
            self.inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Host" style:UIBarButtonItemStyleBordered target:nil action:nil];
            break;
        case MBDInputModeTileMill2:
            self.title = @"TileMill 2";
            self.inputLabel.text = @"e.g. 10.0.1.7 or Joe.local";
            self.inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Host" style:UIBarButtonItemStyleBordered target:nil action:nil];
            break;
    }
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    UIViewController *viewController;

    switch (self.inputMode)
    {
        case MBDInputModeMapID:
            viewController = [[MBDMapViewController alloc] initWithMapID:textField.text];
            break;
        case MBDInputModeTileMill1:
            viewController = [[MBDProjectViewController alloc] initWithHost:textField.text];
            break;
        case MBDInputModeTileMill2:
            // TODO
            break;
    }

    [self.navigationController pushViewController:viewController animated:YES];

    return YES;
}

@end
