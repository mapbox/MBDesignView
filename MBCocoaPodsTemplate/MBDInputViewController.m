//
//  MBDInputViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/4/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBDInputViewController.h"

#import "MBDMapViewController.h"

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
            self.inputLabel.text = @"e.g. 10.0.10.7";
            self.inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Address" style:UIBarButtonItemStyleBordered target:nil action:nil];
            break;
        case MBDInputModeTileMill2:
            self.title = @"TileMill 2";
            self.inputLabel.text = @"e.g. 10.0.10.7";
            self.inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Address" style:UIBarButtonItemStyleBordered target:nil action:nil];
            break;
    }
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    MBDMapViewController *mapViewController;
    NSURL *hostURL;

    switch (self.inputMode)
    {
        case MBDInputModeMapID:
            mapViewController = [[MBDMapViewController alloc] initWithTileSource:[[RMMapBoxSource alloc] initWithMapID:textField.text]];
            break;
        case MBDInputModeTileMill1:
            hostURL = [NSURL URLWithString:textField.text];
            mapViewController = [[MBDMapViewController alloc] initWithTileSource:[[RMTileMillSource alloc] initWithHost:@"10.0.7.100" mapName:@"travel" tileCacheKey:@"blah" minZoom:0 maxZoom:10]];
            break;
        case MBDInputModeTileMill2:
            break;
    }

    [self.navigationController pushViewController:mapViewController animated:YES];

    return YES;
}

@end
