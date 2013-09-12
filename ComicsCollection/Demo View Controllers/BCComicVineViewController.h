//
//  BCSecondViewController.h
//  ComicsCollection
//
//  Created by Bryan Clark on 6/23/13.
//  Copyright (c) 2013 Bryan Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCComicVineViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
