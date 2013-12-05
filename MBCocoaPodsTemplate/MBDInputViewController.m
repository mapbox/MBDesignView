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

#import <MBProgressHUD/MBProgressHUD.h>

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.inputField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)])
    {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[inputLabel]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{ @"topLayoutGuide" : self.topLayoutGuide, @"inputLabel" : self.inputLabel }]];

        [self.view layoutSubviews];
    }
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    NSURL *validationURL;
    NSString *errorTitle;
    UIViewController *viewController;

    switch (self.inputMode)
    {
        case MBDInputModeMapID:
        {
            validationURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.tiles.mapbox.com/v3/%@.json", textField.text]];
            errorTitle = @"Bad Map ID";
            viewController = [[MBDMapViewController alloc] initWithMapID:textField.text];
            break;
        }
        case MBDInputModeTileMill1:
        {
            validationURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:20009/api/Project", textField.text]];
            errorTitle = @"Bad Host";
            viewController = [[MBDProjectViewController alloc] initWithHost:textField.text];
            break;
        }
        case MBDInputModeTileMill2:
        {
            // TODO
            break;
        }
    }

    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:progressHUD];
    [progressHUD show:YES];

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:validationURL]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                           {
                               if (((NSHTTPURLResponse *)response).statusCode == 200 && data)
                               {
                                   [self.navigationController pushViewController:viewController animated:YES];
                               }
                               else
                               {
                                   [[[UIAlertView alloc] initWithTitle:errorTitle
                                                               message:@"That didn't work. Please try again."
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Try Again", nil] show];
                               }

                               [progressHUD hide:YES];
                           }];

    return YES;
}

@end
