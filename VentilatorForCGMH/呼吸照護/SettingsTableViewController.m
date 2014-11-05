//
//  SettingsTableViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/10/29.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "HospitalViewCell.h"
#import "CareSortViewCell.h"
#import "MainViewController.h"
#import "PListManager.h"

#define HOSPITAL_SECTION 0
#define CARESORT_SECTION 1

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController {
    PListManager *plManager;
    NSDictionary *hospital;
    NSDictionary *careSort;
}

@synthesize checkedHospitalIndexPath, checkedCareSortIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainViewController *mainViewController = (MainViewController *)((UINavigationController *)self.parentViewController).parentViewController;
    plManager = [mainViewController getPListManager];
    hospital = [plManager getHospital];
    careSort = [plManager getCareSort];

    [self setCurrentCheckmark];
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
    
    switch (indexPath.section) {
        case 0: {
            if(self.checkedHospitalIndexPath && ![self.checkedHospitalIndexPath isEqual:indexPath])
            {
                HospitalViewCell* uncheckCell = (HospitalViewCell *)[tableView cellForRowAtIndexPath:self.checkedHospitalIndexPath];
                uncheckCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            HospitalViewCell* cell = (HospitalViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.checkedHospitalIndexPath = indexPath;
            [self writeHospitalName:cell.Name IpAddress:cell.IpAddress];
            break;
        }
            
        case 1: {
            if (self.checkedCareSortIndexPath && ![self.checkedCareSortIndexPath isEqual:indexPath]) {
                CareSortViewCell *unckeckCell = (CareSortViewCell *)[tableView cellForRowAtIndexPath:self.checkedCareSortIndexPath];
                unckeckCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            CareSortViewCell *cell = (CareSortViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.checkedCareSortIndexPath = indexPath;
            [self writeCareSortByKey:cell.Key Ascending:cell.Ascending];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Private Method
- (void)setCurrentCheckmark {
    //院區
    NSString *hospitalName = [hospital objectForKey:@"Name"];
    if (![hospitalName isEqualToString:@""]) {
        for (int i = 0; i < [self.tableView numberOfRowsInSection:HOSPITAL_SECTION]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:HOSPITAL_SECTION];
            HospitalViewCell *cell = (HospitalViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell.Name isEqualToString:hospitalName]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.checkedHospitalIndexPath = [self.tableView indexPathForCell:cell];
                break;
            }
        }
    }
    
    //照護記錄排序
    NSString *careSortKey = [careSort objectForKey:@"Key"];
    if (![careSortKey isEqualToString:@""]) {
        for (int i = 0; i < [self.tableView numberOfRowsInSection:CARESORT_SECTION]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:CARESORT_SECTION];
            CareSortViewCell *cell = (CareSortViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell.Key isEqualToString:careSortKey] && [[careSort objectForKey:@"Ascending"] isEqualToNumber:[NSNumber numberWithBool:cell.Ascending]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.checkedCareSortIndexPath = [self.tableView indexPathForCell:cell];
                break;
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

- (void)writeCareSortByKey:(NSString *)Key Ascending:(BOOL)Ascending {
    if ([[careSort objectForKey:@"Key"] isEqualToString:Key] && [[careSort objectForKey:@"Ascending"] isEqualToNumber:[NSNumber numberWithBool:Ascending]]) {
        return;
    }
    careSort = [[NSDictionary alloc] initWithObjects:@[Key, [NSNumber numberWithBool:Ascending]] forKeys:@[@"Key", @"Ascending"]];
    [plManager writeCareSortValue:careSort];
}
@end
