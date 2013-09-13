//
//  BCEntryViewController.h
//  ComicsCollection
//
//  Created by Bryan Clark on 9/11/13.
//  Copyright (c) 2013 Bryan Clark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCEntryViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *resourceTextField;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)submitButtonTapped:(UIButton *)sender;

@end
