//
//  ContentCollectionView.m
//  CollectionViewTest
//
//  Created by Farland on 2014/5/16.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "ContentCollectionView.h"

#import "HistoryCollectionViewController.h"
#import "ContentCell.h"
#import "CollectionViewFlowLayout.h"

@interface ContentCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation ContentCollectionView {
    NSUInteger dataCount;
}

@synthesize protocol;
@synthesize dataArray;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDataSource:self];
        [self setDelegate:self];
        dataCount = 0;
        
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    protocol = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{3
    // Drawing code
}
*/

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [dataArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ContentCell *cell = (ContentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Foo Cell" forIndexPath:indexPath];
    
    //清除已存在的內容避免memory leak
    [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < ARRAY_TITLE.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, HEADER_HEIGHT * i, HEADER_WIDTH, HEADER_HEIGHT)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:dataArray[indexPath.row][i] == nil || [((NSString *)dataArray[indexPath.row][i]) isEqualToString:@"(null)"] ? @"" : dataArray[indexPath.row][i]];
        
        //Add bottom border
        CGFloat borderSize = 1.0f;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, label.frame.size.height - borderSize, label.frame.size.width, borderSize);
        
        bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
        
        [label.layer addSublayer:bottomBorder];
        
        //最後一筆，畫右邊的線
        if (dataCount == dataArray.count - 1) {
            CALayer *rightBorder = [CALayer layer];
            rightBorder.frame = CGRectMake(HEADER_WIDTH - borderSize, 0.0f, borderSize, HEADER_HEIGHT);
            
            rightBorder.backgroundColor = [UIColor grayColor].CGColor;
            
            [label.layer addSublayer:rightBorder];
        }
        
        [cell addSubview:label];
    }
    
    dataCount++;
    
    return cell;
}

#pragma mark - UICollectionView Delegate FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HEADER_WIDTH, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (protocol != nil && [protocol respondsToSelector:@selector(collectionViewDidScroll)]) {
        [protocol collectionViewDidScroll];
    }
}


@end
