//
//  SettingsTableViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/10/29.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "HospitalViewCell.h"
#import "PListManager.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController {
    PListManager *plManager;
    NSDictionary *hospital;
}

@synthesize checkedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    plManager = [[PListManager alloc] initWithPListName:@"Properties"];
    hospital = [plManager readDictionaryByKey:@"Hospital"];

    [self setCurrentHospitalWithCheckmark];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    [self setCurrentHospital];
//}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do work for checkmark
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section > 0) {
        return;
    }
    
    if(self.checkedIndexPath && ![self.checkedIndexPath isEqual:indexPath])
    {
        HospitalViewCell* uncheckCell = (HospitalViewCell *)[tableView cellForRowAtIndexPath:self.checkedIndexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    HospitalViewCell* cell = (HospitalViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkedIndexPath = indexPath;
    [self writeHospitalName:cell.Name IpAddress:cell.IpAddress];
}

#pragma mark - Private Method
- (void)setCurrentHospitalWithCheckmark {
    NSString *hospitalName = [hospital objectForKey:@"Name"];
    if (![hospitalName isEqualToString:@""]) {
        for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            HospitalViewCell *cell = (HospitalViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell.Name isEqualToString:hospitalName]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.checkedIndexPath = [self.tableView indexPathForCell:cell];
                return;
            }
        }
    }
}

- (void)writeHospitalName:(NSString *)Name IpAddress:(NSString *)IpAddress {
    if ([[hospital objectForKey:@"Name"] isEqualToString:Name]) {
        return;
    }
    hospital = [[NSDictionary alloc] initWithObjects:@[Name, IpAddress] forKeys:@[@"Name", @"IpAddress"]];
    [plManager writeByKey:@"Hospital" value:hospital];
}

- (IBAction)test:(id)sender {
    NSString *hospitalName = [hospital objectForKey:@"Name"];
    if (![hospitalName isEqualToString:@""]) {
        for (HospitalViewCell *cell in [self.tableView dequeueReusableCellWithIdentifier:@"Hospital Cell"]) {
            if ([cell.Name isEqualToString:hospitalName]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.checkedIndexPath = [self.tableView indexPathForCell:cell];
                return;
            }
        }
    }
}
@end
