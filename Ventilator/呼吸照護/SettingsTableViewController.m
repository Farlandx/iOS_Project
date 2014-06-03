//
//  SettingsTableViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/5/29.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "MainViewController.h"
#import "DatabaseUtility.h"

@interface SettingsTableViewController () <UIAlertViewDelegate>

@end

@implementation SettingsTableViewController {
    MainViewController *mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainView = (MainViewController *)(self.parentViewController).parentViewController;
    
    [self.cellServer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showServerPathDialog)]];
    self.labelServer.text = mainView.serverPath;
    
    if ([MainViewController IsDemoMode]) {
        [self.imgCheckbox setImage:[UIImage imageNamed:@"checked"]];
    }
    [self.imgCheckbox addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDemoMode)]];
    
    self.labelVersion.text = [NSString stringWithFormat:@"版本: %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showServerPathDialog {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"請輸入伺服器位置" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = self.labelServer.text;
    [textField setPlaceholder:@"ex: http://example.com/"];
    [textField setKeyboardType:UIKeyboardTypeURL];
    [alertView show];
}

- (void)toggleDemoMode {
    [MainViewController SetDemoMode:![MainViewController IsDemoMode]];
    if ([MainViewController IsDemoMode]) {
        [self.imgCheckbox setImage:[UIImage imageNamed:@"checked"]];
    }
    else {
        [self.imgCheckbox setImage:[UIImage imageNamed:@"unchecked"]];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *path = [alertView textFieldAtIndex:0].text;
        
        if (path.length) {
            //開頭加上http://
            if (path.length < 7 || ![[path substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"http://"]) {
                path = [@"http://" stringByAppendingString:path];
            }
            //尾巴加上/
            if (![[path substringFromIndex:path.length - 1] isEqualToString:@"/"]) {
                path = [path stringByAppendingString:@"/"];
            }
            
        }
        self.labelServer.text = path;
        DatabaseUtility *db = [[DatabaseUtility alloc] init];
        [db saveServerPath:self.labelServer.text];
    }
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 2;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
