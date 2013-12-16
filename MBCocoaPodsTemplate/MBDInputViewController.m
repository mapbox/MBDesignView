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
#import "MBDBrowseViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBDInputViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) MBDInputMode inputMode;
@property (nonatomic) IBOutlet UILabel *mapInputLabel;
@property (nonatomic) IBOutlet UITextField *mapInputField;
@property (nonatomic) IBOutlet UILabel *titleInputLabel;
@property (nonatomic) IBOutlet UITextField *titleInputField;
@property (nonatomic) IBOutlet UILabel *colorInputLabel;
@property (nonatomic) IBOutlet UITextField *colorInputField;

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
            self.title = @"Hosted Map";
            self.mapInputLabel.text = @"Map ID";
            self.mapInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastMapID"];
            self.mapInputField.placeholder = @"e.g. examples.greatmap";
            self.titleInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastHostedTitle"];
            self.colorInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastHostedColor"];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map ID" style:UIBarButtonItemStyleBordered target:nil action:nil];
            break;
        case MBDInputModeTileMill1:
            self.title = @"TileMill 1";
            self.mapInputLabel.text = @"Host";
            self.mapInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastTileMill1Host"];
            self.mapInputField.placeholder = @"e.g. 10.0.1.7 or Joe.local";
            self.mapInputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.titleInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastTileMill1Title"];
            self.colorInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastTileMill1Color"];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Host" style:UIBarButtonItemStyleBordered target:nil action:nil];
            break;
        case MBDInputModeTileMill2:
            self.title = @"TileMill 2";
            self.mapInputLabel.text = @"Host";
            self.mapInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastTileMill2Host"];
            self.mapInputField.placeholder = @"e.g. 10.0.1.7 or Joe.local";
            self.mapInputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.titleInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastTileMill2Title"];
            self.colorInputField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastTileMill2Color"];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Host" style:UIBarButtonItemStyleBordered target:nil action:nil];
            break;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(performNext:)];
    self.navigationItem.rightBarButtonItem.enabled = ([self.mapInputField.text length] > 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.mapInputField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    if ([UIViewController instancesRespondToSelector:@selector(topLayoutGuide)])
    {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[inputLabel]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{ @"topLayoutGuide" : self.topLayoutGuide, @"inputLabel" : self.mapInputLabel }]];

        [self.view layoutSubviews];
    }
}

#pragma mark -

- (void)performNext:(id)sender
{
    NSURL *validationURL;
    NSString *mapDefaultsKey, *titleDefaultsKey, *colorDefaultsKey;
    UIViewController *viewController;
    NSString *errorTitle;

    switch (self.inputMode)
    {
        case MBDInputModeMapID:
        {
            validationURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.tiles.mapbox.com/v3/%@.json", self.mapInputField.text]];
            mapDefaultsKey = @"lastMapID";
            titleDefaultsKey = @"lastHostedTitle";
            colorDefaultsKey = @"lastHostedColor";
            viewController = [[MBDMapViewController alloc] initWithMapID:self.mapInputField.text];
            errorTitle = @"Bad Map ID";
            break;
        }
        case MBDInputModeTileMill1:
        {
            validationURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:20009/api/Project", self.mapInputField.text]];
            mapDefaultsKey = @"lastTileMill1Host";
            titleDefaultsKey = @"lastTileMill1Title";
            colorDefaultsKey = @"lastTileMill1Color";
            viewController = [[MBDProjectViewController alloc] initWithHost:self.mapInputField.text];
            errorTitle = @"Bad Host";
            break;
        }
        case MBDInputModeTileMill2:
        {
            validationURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:3000/browse", self.mapInputField.text]];
            mapDefaultsKey = @"lastTileMill2Host";
            titleDefaultsKey = @"lastTileMill2Title";
            colorDefaultsKey = @"lastTileMill2Color";
            viewController = [[MBDBrowseViewController alloc] initWithHost:self.mapInputField.text path:@""];
            errorTitle = @"Bad Host";
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
                                   [[NSUserDefaults standardUserDefaults] setValue:self.mapInputField.text forKey:mapDefaultsKey];
                                   [[NSUserDefaults standardUserDefaults] setValue:self.titleInputField.text forKey:titleDefaultsKey];
                                   [[NSUserDefaults standardUserDefaults] setValue:self.colorInputField.text forKey:colorDefaultsKey];
                                   [[NSUserDefaults standardUserDefaults] synchronize];

                                   [self.navigationController pushViewController:viewController animated:YES];
                               }
                               else
                               {
                                   [[[UIAlertView alloc] initWithTitle:errorTitle
                                                               message:@"That didn't work. Please try again."
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Try Again", nil] show];
                               }

                               [progressHUD hide:YES];
                           }];
}

- (void)validateMapField:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem.enabled = ([textField.text length] > 0);
}

#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.mapInputField])
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(validateMapField:) object:textField];

        [self performSelector:@selector(validateMapField:) withObject:textField afterDelay:0.5];
    }

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([textField isEqual:self.mapInputField])
        self.navigationItem.rightBarButtonItem.enabled = NO;

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.mapInputField becomeFirstResponder];
}

@end
