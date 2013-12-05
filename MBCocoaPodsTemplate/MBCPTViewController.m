//
//  MBCPTViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 11/1/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBCPTViewController.h"

#import "MBDInputViewController.h"

@interface MBCPTViewController ()

- (IBAction)tappedModeButton:(id)sender;

@end

@implementation MBCPTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        self.title = @"MapBox Design";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleBordered target:nil action:nil];
    }

    return self;
}

- (IBAction)tappedModeButton:(id)sender
{
    [self.navigationController pushViewController:[[MBDInputViewController alloc] initWithInputMode:((UIView *)sender).tag] animated:YES];
}

@end
