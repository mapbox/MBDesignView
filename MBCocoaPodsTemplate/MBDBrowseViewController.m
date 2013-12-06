//
//  MBDBrowseViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/5/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBDBrowseViewController.h"

#import "MBDMapViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBDBrowseViewController ()

@property (nonatomic) NSString *host;
@property (nonatomic) NSString *path;
@property (nonatomic) NSArray *items;
@property (nonatomic) MBProgressHUD *progressHUD;

@end

@implementation MBDBrowseViewController

- (id)initWithHost:(NSString *)host path:(NSString *)path
{
    self = [super initWithStyle:UITableViewStylePlain];

    if (self)
    {
        _host = host;
        _path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    return self;
}

- (void)viewDidLoad
{
    self.title = ([self.path length] ? [[self.path lastPathComponent] stringByRemovingPercentEncoding] : self.host);

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ( ! [self.items count])
        [self reload:self];
}

#pragma mark -

- (void)reload:(id)sender
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.progressHUD];
    [self.progressHUD show:YES];

    self.items = @[];

    [self.tableView reloadData];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        NSData *itemData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:3000/browse/%@", self.host, self.path]]];

        if (itemData)
        {
            NSArray *items = [NSJSONSerialization JSONObjectWithData:itemData options:0 error:nil];

            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                self.items = items;

                [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];

                [self.progressHUD hide:YES afterDelay:1.0];
            });
        }
   });
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.items ? [self.items count] : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];

    if ([UIView instancesRespondToSelector:@selector(tintColor)])
    {
        cell.selectedBackgroundView.backgroundColor = self.navigationController.navigationBar.tintColor;
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    else
    {
        cell.textLabel.textColor = self.navigationController.navigationBar.tintColor;
        cell.selectedBackgroundView.backgroundColor = self.navigationController.navigationBar.tintColor;
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    }

    cell.textLabel.text = [self.items[indexPath.row] valueForKey:@"basename"];

    if ([[self.items[indexPath.row] valueForKey:@"type"] isEqualToString:@"dir"] && ! [[self.items[indexPath.row] valueForKey:@"extname"] isEqualToString:@".tm2"])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([[self.items[indexPath.row] valueForKey:@"extname"] isEqualToString:@".tm2"])
    {
        cell.textLabel.textColor = self.navigationController.navigationBar.tintColor;
    }
    else
    {
        cell.textLabel.enabled = NO;
    }

    return cell;
}

#pragma mark -

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.items[indexPath.row] valueForKey:@"type"] isEqualToString:@"dir"] || [[self.items[indexPath.row] valueForKey:@"extname"] isEqualToString:@".tm2"])
    {
        return indexPath;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([[self.items[indexPath.row] valueForKey:@"type"] isEqualToString:@"dir"] && ! [[self.items[indexPath.row] valueForKey:@"extname"] isEqualToString:@".tm2"])
    {
        NSString *pushPath = [NSString stringWithFormat:@"%@/%@", self.path, [self.items[indexPath.row] valueForKey:@"basename"]];

        [self.navigationController pushViewController:[[MBDBrowseViewController alloc] initWithHost:self.host path:pushPath] animated:YES];
    }
    else if ([[self.items[indexPath.row] valueForKey:@"extname"] isEqualToString:@".tm2"])
    {
        [self.navigationController pushViewController:[[MBDMapViewController alloc] initWithHost:self.host projectPath:[self.items[indexPath.row] valueForKey:@"path"]] animated:YES];
    }
}

@end
