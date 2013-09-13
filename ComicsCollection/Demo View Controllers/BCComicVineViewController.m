//
//  BCSecondViewController.m
//  ComicsCollection
//
//  Created by Bryan Clark on 6/23/13.
//  Copyright (c) 2013 Bryan Clark. All rights reserved.
//

#import "BCComicVineViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "BCComicCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BCAppDelegate.h"

@interface BCComicVineViewController ()

@property (nonatomic, strong) BCComicVineClient *comicVine;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation BCComicVineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.comicVine = [BCComicVineClient sharedComicVineClient];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BCAppDelegate *appDelegate = (BCAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.term) {
        self.searchTerm = @"batman";
    }
    if (![appDelegate.term isEqualToString:self.searchTerm]) {
        self.images = [NSMutableArray array];
        [self.comicVine searchWithQuery:self.searchTerm
                                  limit:30
                                 offset:0
                      completionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
                          NSArray *results = JSON[@"results"];
                          for (int i = 0; i < [results count]; i++) {
                              NSString *imageURL = results[i][@"image"][@"small_url"];
                              [self.images addObject:imageURL];
                          }
                          [self.collectionView reloadData];
                      }];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.images count]/3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BCComicCell *cell = (BCComicCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSInteger imageIndex = (indexPath.section * 3) + indexPath.row;
    
    if ([self.images count] > 0) {
        if (imageIndex < ([self.images count] - 1)) {
            NSURL *imageURL = [NSURL URLWithString:self.images[imageIndex]];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIImage *image = [UIImage imageWithData:(NSData *)responseObject];
                cell.imageView.image = image;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            [op start];
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(106, 160);
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 2, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0f;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = (3 * indexPath.section) + indexPath.row;

//    BCComicCell *cell = (BCComicCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    UIImage *image = cell.imageView.image;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.image = image;
//    imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(largeImageTapped:)];
//    [imageView addGestureRecognizer:tap];
//    [UIView animateWithDuration:0.3
//                          delay:0.0
//         usingSpringWithDamping:0.5
//          initialSpringVelocity:0.1
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         [self.view addSubview:imageView];
//                     }
//                     completion:nil];
}

- (void)largeImageTapped:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [view removeFromSuperview];
                     }
                     completion:nil];
}
@end
