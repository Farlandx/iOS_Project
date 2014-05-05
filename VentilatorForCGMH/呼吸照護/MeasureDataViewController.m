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
#import "WebService.h"
#import "DtoVentExchangeUploadBatch.h"
#import "DtoUploadVentDataResult.h"
#import "DeviceStatus.h"

@interface MeasureDataViewController ()<MeasureViewControllerDelegate, WebServiceDelegate>

@end

@implementation MeasureDataViewController {
    DatabaseUtility *db;
    WebService *ws;
    NSString *uploadOper;
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
    uploadOper = @"E221104037";
    NSLog(@"%@", [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]);
    
    db = [[DatabaseUtility alloc] init];
    [db initDatabase];
    
    ws = [[WebService alloc] init];
    ws.delegate = self;
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
        
    }
    else {
        NSLog(@"no");
    }
}

#pragma mark - WebService Delegate
- (void)wsAppLogin:(NSString *)sessionId {
    sessionId = sessionId;
    NSLog(@"sessionId:%@", sessionId);
    if (sessionId != nil && ![sessionId isEqualToString:@""]) {
        [ws uploadVentDataBySessionId:sessionId DtoVentExchangeUploadBatch:[self getDataListToUploadDataByDeviceUUID:[DeviceStatus getDeviceVendorUUID]]];
    }
}

- (void)wsUploadVentData:(NSMutableArray *)uploadResult DtoVentExchangeUploadBatch:(DtoVentExchangeUploadBatch *)batch{
    NSLog(@"uploadResult count:%ld", [uploadResult count]);
    int index = 0;
    NSMutableArray *removeList = [[NSMutableArray alloc] init];
    NSMutableArray *removeBatchList = [[NSMutableArray alloc] init];
    for (DtoUploadVentDataResult *dvd in uploadResult) {
        if (dvd.Success) {
            //上傳成功的資料從list中移除
            [removeList addObject:measureDataList[index]];
        }
        else {
            //失敗的資料從batch中移除
            [removeBatchList addObject:batch.VentRecList[index]];
        }
        index++;
    }
    
    //刪除measureDataList中的資料
    for (VentilationData *vd in removeList) {
        [measureDataList removeObject:vd];
    }
    
    //刪除batch中的資料
    for (VentilationData *vd in removeBatchList) {
        [batch.VentRecList removeObject:vd];
    }
    
    if (batch.VentRecList.count > 0) {
        [db saveUploadData:batch];
    }
    [self.tableView reloadData];
}

- (void)wsResponseCurRtCardList:(NSMutableArray *)data {
    NSLog(@"wsResponseCurRtCardList count:%ld", [data count]);
}

- (void)wsResponseCurRtCardListVerId:(int)verId {
    NSLog(@"wsResponseCurRtCardListVerId:%d", verId);
}

- (void)wsResponsePatientList:(NSMutableArray *)data {
    NSLog(@"wsResponsePatientList count:%ld", [data count]);
    for (int i = 0; i < data.count; i++) {
        NSLog(@"patient.ChtNo:%@\tBedNo:%@", [data[i] valueForKeyPath:@"ChtNo.text"], [data[i] valueForKeyPath:@"BedNo.text"]);
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

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Detemine if it's in editing mode
//    if (self.editing)
//    {
//        return UITableViewCellEditingStyleDelete;
//    }
//    
//    return UITableViewCellEditingStyleNone;
//}

//讓刪除鈕變成中文
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"刪除";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VentilationData *data = [measureDataList objectAtIndex:indexPath.row];
        if ([db deleteMeasure:data]) {
            [measureDataList removeObjectAtIndex:indexPath.row];
            // Delete the row from the data source
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

#pragma mark - Button Click
- (IBAction)uploadClick:(id)sender {
    //[ws appLoginDeviceName:[DeviceStatus getDeviceVendorUUID] idNo:uploadOper];
    
    //[ws getCurRtCardListVerId];
    
    //[ws getCurRtCardList];
    
    [ws getPatientList];
}

#pragma mark - Private Method
- (DtoVentExchangeUploadBatch *)getDataListToUploadDataByDeviceUUID:(NSString *)deviceUUID {
    if (![uploadOper isEqualToString:@""] && [measureDataList count] > 0) {
        //組上傳資料
        DtoVentExchangeUploadBatch *batch = [[DtoVentExchangeUploadBatch alloc] init];
        batch.UploadOper = uploadOper;
        batch.UploadIp = [DeviceStatus getCurrentIPAddress];
        batch.UploadTime = [DeviceStatus getSystemTime];
        batch.Device = deviceUUID;
        batch.ClientVersion = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];;
        batch.VentRecList = measureDataList;
        return batch;
    }
    return nil;
}
@end
