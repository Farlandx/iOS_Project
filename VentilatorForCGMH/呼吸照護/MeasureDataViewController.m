//
//  MeasureDataViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/2/19.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "MeasureDataViewController.h"
#import "VentilationData.h"
#import "DataTableViewCell.h"
#import "MeasureViewController.h"
#import "DatabaseUtility.h"

@interface MeasureDataViewController ()<MeasureViewControllerDelegate>

@end

@implementation MeasureDataViewController {
    DatabaseUtility *db;
}

@synthesize measureDataList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    db = [[DatabaseUtility alloc] init];
    [db initDatabase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    measureDataList = [db getMeasures];
    
    [self.tableView reloadData];
}

#pragma mark - Delegate
- (void)measureViewControllerDismissed:(VentilationData *)measureData {
    if (measureData != nil) {
        //儲存成功後返回的資料
    }
    else {
        NSLog(@"no");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [measureDataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Data Cell";
    DataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    VentilationData *data = [measureDataList objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.labelRecordTime.text = data.RecordTime;
    cell.labelChtNo.text = data.ChtNo;
    cell.labelRecordOper.text = data.RecordOper;
    cell.labelVentilationMode.text = data.VentilationMode;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    if (self.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *nc = [segue destinationViewController];
    for (UIView *v in nc.viewControllers) {
        if ([v isKindOfClass:[MeasureViewController class]]) {
            MeasureViewController *vc = (MeasureViewController *)v;
            if ([[segue identifier] isEqualToString:@"Add segue"]) {
                // 新增
                VentilationData *foo = [[VentilationData alloc] init];
                [foo setDefaultValue];
                vc.myMeasureData = foo;
                vc.delegate = self;
            }
            else if ([[segue identifier] isEqualToString:@"Edit segue"]) {
                // 編輯
                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                vc.myMeasureData = [measureDataList objectAtIndex: indexPath.row];
                vc.delegate = self;
            }
        }
    }
}

@end
