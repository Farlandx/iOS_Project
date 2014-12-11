//
//  HistoryViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/5/28.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "HistoryViewController.h"
#import "MainViewController.h"

#define PRINT_TABLE_URL @"%@Service/RespiratoryPrintTable?id=%@&startdate=%@&enddate=%@"
#define HISTORY_DAY -3

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSDateComponents *dateComponets = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *endDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]];
    
    [dateComponets setDay:HISTORY_DAY];
    NSString *startDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRINT_TABLE_URL,
                                       ((MainViewController *)self.parentViewController.parentViewController).serverPath,
                                       self.MedicalId,
                                       startDate,
                                       endDate]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - AirPrint
- (NSData *)createPDFfromUIView:(UIView*)aView {
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    return pdfData;
}

- (IBAction)printView:(id)sender {
//    NSData *uiViewPdfData = [self createPDFfromUIView:self.webView];
//    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
//    
//    if(pic && [UIPrintInteractionController canPrintData: uiViewPdfData] ) {
//        
//        //        pic.delegate = self;
//        
//        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
//        printInfo.outputType = UIPrintInfoOutputGeneral;
//        printInfo.jobName = @"iOS Ventilation History";
//        printInfo.duplex = UIPrintInfoDuplexLongEdge;
//        pic.printInfo = printInfo;
//        pic.showsPageRange = YES;
//        pic.printingItem = uiViewPdfData;
//        
//        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
//            //self.content = nil;
//            if (!completed && error) {
//                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
//            }
//        };
//        
//        [pic presentAnimated:YES completionHandler:completionHandler];
//        
//    }
    
    UIPrintInfo *pi = [UIPrintInfo printInfo];
    pi.outputType = UIPrintInfoOutputGeneral;
    pi.jobName = self.webView.request.URL.absoluteString;
    pi.orientation = UIPrintInfoOrientationPortrait;
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.printInfo = pi;
    pic.showsPageRange= YES;
    UIPrintPageRenderer *renderer = [[UIPrintPageRenderer alloc] init];
    self.webView.viewPrintFormatter.printPageRenderer.headerHeight = 30.0f;
    self.webView.viewPrintFormatter.printPageRenderer.footerHeight = 30.0f;
    self.webView.viewPrintFormatter.contentInsets = UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f);
    self.webView.viewPrintFormatter.startPage = 0;
    [renderer addPrintFormatter:self.webView.viewPrintFormatter startingAtPageAtIndex:0];
    pic.printPageRenderer = renderer;
    
    [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController *pic2, BOOL completed, NSError *error) {
        // indicate done or error
    }];
}

@end
