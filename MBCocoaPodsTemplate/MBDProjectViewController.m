//
//  MBDProjectViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/4/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBDProjectViewController.h"

#import "MBDMapViewController.h"

#import <MapBox/MapBox.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBDProjectViewController ()

@property (nonatomic) NSString *host;
@property (nonatomic) NSArray *projects;
@property (nonatomic) MBProgressHUD *progressHUD;

@end

@implementation MBDProjectViewController

- (id)initWithHost:(NSString *)host
{
    self = [super initWithStyle:UITableViewStylePlain];

    if (self)
        _host = host;

    return self;
}

- (void)viewDidLoad
{
    self.title = @"Projects";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ( ! [self.projects count])
    {
        self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.progressHUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:self.progressHUD];
        [self.progressHUD show:YES];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
        {
            NSArray *projects = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:20009/api/Project", self.host]]]
                                                                options:0
                                                                  error:nil];

            NSArray *sortedProjects = [projects sortedArrayWithOptions:0
                                                       usingComparator:^NSComparisonResult(id obj1, id obj2)
                                                       {
                                                           NSString *name1 = ([[obj1 valueForKey:@"name"] length] ? [obj1 valueForKey:@"name"] : [obj1 valueForKey:@"id"]);
                                                           NSString *name2 = ([[obj2 valueForKey:@"name"] length] ? [obj2 valueForKey:@"name"] : [obj2 valueForKey:@"id"]);

                                                           return [name1 compare:name2 options:NSCaseInsensitiveSearch];
                                                       }];

            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
                self.projects = sortedProjects;

                [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];

                [self.progressHUD hide:YES afterDelay:1.0];
            });
        });
    }
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.projects ? [self.projects count] : 0);
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

    cell.textLabel.text = ([[self.projects[indexPath.row] valueForKey:@"name"] length] ? [self.projects[indexPath.row] valueForKey:@"name"] : [self.projects[indexPath.row] valueForKey:@"id"]);

    return cell;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.navigationController pushViewController:[[MBDMapViewController alloc] initWithHost:self.host projectInfo:self.projects[indexPath.row]] animated:YES];
}

@end
