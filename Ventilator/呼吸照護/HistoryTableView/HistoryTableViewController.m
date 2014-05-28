//
//  HistoryTableViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/5/12.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryTableViewCell.h"
#import "APLSectionInfo.h"
#import "VentilationData.h"
#import "MainViewController.h"
#import "DtoVentExchangeUploadBatch.h"
#import "HistoryCollectionViewController.h"
#import "MeasureViewController.h"

#pragma mark - HistoryTableViewController

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface HistoryTableViewController ()

@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSIndexPath *pinchedIndexPath;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) CGFloat initialPinchHeight;

@property (nonatomic) IBOutlet APLSectionHeaderView *sectionHeaderView;

// use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously
@property (nonatomic) NSInteger uniformRowHeight;

@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 44
#define SECTION_HEADER_HEIGHT 68

@implementation HistoryTableViewController

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

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
    
    // Set up default values.
    self.tableView.sectionHeaderHeight = SECTION_HEADER_HEIGHT;
	/*
     The section info array is thrown away in viewWillUnload, so it's OK to set the default values here. If you keep the section information etc. then set the default values in the designated initializer.
     */
    self.uniformRowHeight = DEFAULT_ROW_HEIGHT;
    self.openSectionIndex = NSNotFound;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
    
    //Get MainViewController
    MainViewController *mainViewController = (MainViewController *)((UINavigationController *)self.parentViewController).parentViewController;
    
    /*
     Check whether the section info array has been created, and if so whether the section count still matches the current section count. In general, you need to keep the section info synchronized with the rows and section. If you support editing in the table view, you need to appropriately update the section info during editing operations.
     */
	if ((self.sectionInfoArray == nil) ||
        ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
        
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
        self.batchAry = mainViewController.historyList;
        
		for (DtoVentExchangeUploadBatch *batch in self.batchAry) {
            
			APLSectionInfo *sectionInfo = [[APLSectionInfo alloc] init];
			sectionInfo.batch = batch;
			sectionInfo.open = NO;
            
            NSNumber *defaultRowHeight = @(DEFAULT_ROW_HEIGHT);
			NSInteger countOfVentRecList = [[sectionInfo.batch VentRecList] count];
			for (NSInteger i = 0; i < countOfVentRecList; i++) {
				[sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
			}
            
			[infoArray addObject:sectionInfo];
		}
        
		self.sectionInfoArray = infoArray;
        [self.tableView reloadData];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.batchAry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	APLSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
	NSInteger numVentRecsInSection = [[sectionInfo.batch VentRecList] count];
    
    return sectionInfo.open ? numVentRecsInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    HistoryTableViewCell *cell = (HistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DtoVentExchangeUploadBatch *batch = (DtoVentExchangeUploadBatch *)[(self.sectionInfoArray)[indexPath.section] batch];
    NSArray *tagAry = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:indexPath.section], [NSNumber numberWithInteger:indexPath.row], nil];
    [cell setTag:(NSInteger)tagAry];
    cell.ChtNo.text = ((VentilationData *)batch.VentRecList[indexPath.row]).ChtNo;
    cell.RecordOper.text = ((VentilationData *)batch.VentRecList[indexPath.row]).RecordOper;
    cell.VentilationMode.text = ((VentilationData *)batch.VentRecList[indexPath.row]).VentilationMode;
    cell.RecordTime.text = ((VentilationData *)batch.VentRecList[indexPath.row]).RecordTime;
    
    return cell;
}

- (void)headerTapped:(UITapGestureRecognizer *)sender {
    UIView *view = [sender view];
    
    UIStoryboard *storyboard = self.navigationController.storyboard;
    HistoryCollectionViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"historyCollectionViewController"];
    viewController.batchData = self.batchAry[view.tag];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    APLSectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    [sectionHeaderView setTag:section]; //讓tapGesture能夠辯識第幾個Section
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(headerTapped:)];
    
    [sectionHeaderView addGestureRecognizer:tapGesture];

    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, SECTION_HEADER_HEIGHT, sectionHeaderView.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    [sectionHeaderView.layer addSublayer:bottomBorder];
    
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    
    if (sectionInfo.batch.VentRecList.count > 0) {
        //取得第一筆，即最新的資料放在section
        sectionHeaderView.ChtNo.text = ((VentilationData *)sectionInfo.batch.VentRecList[0]).ChtNo;
        sectionHeaderView.RecordOper.text = ((VentilationData *)sectionInfo.batch.VentRecList[0]).RecordOper;
        sectionHeaderView.RecordTime.text = ((VentilationData *)sectionInfo.batch.VentRecList[0]).RecordTime;
        sectionHeaderView.VentilationMode.text = ((VentilationData *)sectionInfo.batch.VentRecList[0]).VentilationMode;
    }
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	APLSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    VentilationData *data = ((DtoVentExchangeUploadBatch *)self.batchAry[indexPath.section]).VentRecList[indexPath.row];
    
    UINavigationController *nc = [segue destinationViewController];
    for (UIView *v in nc.viewControllers) {
        if ([v isKindOfClass:[MeasureViewController class]]) {
            MeasureViewController *vc = (MeasureViewController *)v;
            vc.myMeasureData = data;
            [vc setViewMode];
        }
    }
}

#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
	APLSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.batch.VentRecList count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
		APLSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.batch.VentRecList count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	APLSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

@end
