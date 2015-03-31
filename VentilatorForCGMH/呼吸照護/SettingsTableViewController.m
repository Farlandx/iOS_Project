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
#import "PwdSettingsViewController.h"

#define HOSPITAL_SECTION 0
#define DNS_SETTINGS_SECTION 1
#define CARESORT_SECTION 2
#define OTHER_SETTINGS_SECTION 3

@interface SettingsTableViewController () <PwdSettingDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textDNS;

@end

@implementation SettingsTableViewController {
    PListManager *plManager;
    PwdSettingsViewController *pwdSettings;
    NSDictionary *hospital;
    NSDictionary *careSort;
    
    NSIndexPath *tmpIndexPath;
    
    BOOL isDNSSettingsPwdPassed;
}

@synthesize checkedHospitalIndexPath, checkedCareSortIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textDNS.delegate = self;
    isDNSSettingsPwdPassed = NO;
    
    MainViewController *mainViewController = (MainViewController *)((UINavigationController *)self.parentViewController).parentViewController;
    plManager = [mainViewController getPListManager];
    hospital = [plManager getHospital];
    careSort = [plManager getCareSort];

    [self setCurrentCheckmark];
    
    pwdSettings = [[PwdSettingsViewController alloc] init];
    pwdSettings.delegate = self;
    pwdSettings.plManager = plManager;
}

- (void) viewWillAppear:(BOOL)animated {
    [self resetTmp];
    isDNSSettingsPwdPassed = NO;
    [super viewWillAppear:animated];
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

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _textDNS) {
        tmpIndexPath = [NSIndexPath indexPathForRow:0 inSection:DNS_SETTINGS_SECTION];
        //每次進入設定Tab，只需要驗証一次密碼
        if (!isDNSSettingsPwdPassed) {
            [pwdSettings showInView:self.view.superview.window animated:YES pwdType:PWD_CONFIRM];
        }
        return isDNSSettingsPwdPassed;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _textDNS) {
        [self saveDNS];
    }
    
    return YES;
}

#pragma mark - PwdSettingDelegate
- (void)PwdValid {
    if (tmpIndexPath) {
        switch (tmpIndexPath.section) {
            case HOSPITAL_SECTION: {
                if(self.checkedHospitalIndexPath && ![self.checkedHospitalIndexPath isEqual:tmpIndexPath])
                {
                    HospitalViewCell* uncheckCell = (HospitalViewCell *)[self.tableView cellForRowAtIndexPath:self.checkedHospitalIndexPath];
                    uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                HospitalViewCell* cell = (HospitalViewCell *)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.checkedHospitalIndexPath = tmpIndexPath;
                _textDNS.text = cell.IpAddress;
                [self writeHospitalName:cell.Name IpAddress:cell.IpAddress];
                break;
            }
                
            case DNS_SETTINGS_SECTION: {
                isDNSSettingsPwdPassed = YES;
                [_textDNS becomeFirstResponder];
                break;
            }
                
            case CARESORT_SECTION: {
                if (self.checkedCareSortIndexPath && ![self.checkedCareSortIndexPath isEqual:tmpIndexPath]) {
                    CareSortViewCell *unckeckCell = (CareSortViewCell *)[self.tableView cellForRowAtIndexPath:self.checkedCareSortIndexPath];
                    unckeckCell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                CareSortViewCell *cell = (CareSortViewCell *)[self.tableView cellForRowAtIndexPath:tmpIndexPath];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.checkedCareSortIndexPath = tmpIndexPath;
                [self writeCareSortByKey:cell.Key Ascending:cell.Ascending];
                break;
            }
                
            default:
                break;
        }
    }
    [self resetTmp];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case HOSPITAL_SECTION:
        case CARESORT_SECTION: {
            tmpIndexPath = indexPath;
            [pwdSettings showInView:self.view.superview.window animated:YES pwdType:PWD_CONFIRM];
            break;
        }
            
        case OTHER_SETTINGS_SECTION: {
            if (indexPath.row == 1) {
                //管理員密碼設定
                [pwdSettings showInView:self.view.superview.window animated:YES pwdType:PWD_MODIFY];
            }
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
    _textDNS.text = [hospital objectForKey:@"IpAddress"];
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
    if ([[hospital objectForKey:@"Name"] isEqualToString:Name] && [[hospital objectForKey:@"IpAddress"] isEqualToString:IpAddress]) {
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

- (void)resetTmp {
    tmpIndexPath = nil;
}

- (void)saveDNS {
    if ([_textDNS.text isEqualToString:@""]) {
        return;
    }
    NSString *hospitalName = [hospital objectForKey:@"Name"];
    if (![hospitalName isEqualToString:@""]) {
        for (int i = 0; i < [self.tableView numberOfRowsInSection:HOSPITAL_SECTION]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:HOSPITAL_SECTION];
            HospitalViewCell *cell = (HospitalViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell.Name isEqualToString:hospitalName]) {
                hospital = [[NSDictionary alloc] initWithObjects:@[cell.Name, _textDNS.text] forKeys:@[@"Name", @"IpAddress"]];
                [plManager writeByKey:@"Hospital" value:hospital];
                break;
            }
        }
    }
    
    [_textDNS resignFirstResponder];
}
@end
