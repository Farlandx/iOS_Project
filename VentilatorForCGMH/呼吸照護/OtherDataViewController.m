//
//  OtherDataViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/2/25.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "OtherDataViewController.h"
#import "MeasureData.h"
#import "MeasureTabBarViewController.h"

@interface OtherDataViewController ()

@end

@implementation OtherDataViewController {
    MeasureData *data;
}

@synthesize BreathSounds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _displayView.delegate = self;
    
    for (UIView *v in [_displayView subviews]) {
        if ([v isKindOfClass:[UITextField class]]) {
            ((UITextField *)v).delegate = self;
        }
    }
    
    heightChanged = NO;
    rect.origin = _scrollView.frame.origin;
    rect.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    
    [_textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5f] CGColor]];
    [_textView.layer setBorderWidth:0.5f];
    _textView.delegate = self;
    
    _btnBreathSound.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    if (data.BreathSounds != nil && ![data.BreathSounds isEqualToString:@""]) {
        data.BreathSounds = data.BreathSounds;
        [_btnBreathSound setTitle:data.BreathSounds forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //取得measureData並將資料塞入textfield中
    data = ((MeasureTabBarViewController *)self.tabBarController).measureData;
    if (data != nil) {
        [self setMeasureData:data];
    }
    else {
        data = [[MeasureData alloc] init];
    }
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didKeyboardDismiss {
    _scrollView.frame = rect;
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }];
    heightChanged = NO;
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:_scrollView];
    pt = rc.origin;
    pt.x = 0;
    if (!heightChanged) {
        pt.y -= 200;
        [_scrollView setContentOffset:pt animated:YES];
            
        CGRect newRect;
        newRect.origin = _scrollView.frame.origin;
        newRect.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height - 172);
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.frame = newRect;
        }];
        heightChanged = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didKeyboardDismiss];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:_scrollView];
    pt = rc.origin;
    pt.x = 0;
    if (!heightChanged) {
        if (pt.y > 162) {
            pt.y -= 162;
            [_scrollView setContentOffset:pt animated:YES];
        }
        CGRect newRect;
        newRect.origin = _scrollView.frame.origin;
        newRect.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height - 172);
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.frame = newRect;
        }];
        heightChanged = YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self didKeyboardDismiss];
    
    [textView resignFirstResponder];
    return YES;
}

- (void)displayViewTouchesBeganDone {
    [self didKeyboardDismiss];
}

- (void)breathSoundTableViewDismissWithStringData:(NSString *)sound {
    [_btnBreathSound setTitle:sound forState:UIControlStateNormal];
}

- (void)setMeasureData:(MeasureData *)measureData {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BreathSoundTableViewController *vc = [segue destinationViewController];
    vc.delegate  = self;
}

@end
