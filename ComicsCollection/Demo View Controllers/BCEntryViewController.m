//
//  BCEntryViewController.m
//  ComicsCollection
//
//  Created by Bryan Clark on 9/11/13.
//  Copyright (c) 2013 Bryan Clark. All rights reserved.
//

#import "BCEntryViewController.h"
#import "BCAppDelegate.h"

@interface BCEntryViewController ()

@property (nonatomic, strong) NSMutableArray *comics;
@property (nonatomic, strong) BCComicVineClient *comicVine;

@end

@implementation BCEntryViewController

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
    self.comicVine = [BCComicVineClient sharedComicVineClient];
    self.comics = [NSMutableArray array];
}

- (IBAction)submitButtonTapped:(UIButton *)sender {
    BCAppDelegate *appDelegate = (BCAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.resource = self.resourceTextField.text;
    appDelegate.term = self.searchTextField.text;
    
    if (self.resourceTextField.isFirstResponder) {
        [self.resourceTextField resignFirstResponder];
    }
    if (self.searchTextField.isFirstResponder) {
        [self.searchTextField resignFirstResponder];
    }
    
    [self.comicVine searchWithQuery:self.searchTextField.text
                              limit:30
                             offset:0
                  completionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
                      self.comics = [NSMutableArray array];
                      NSArray *results = JSON[@"results"];
                      for (int i = 0; i < [results count]; i++) {
                          [self.comics addObject:results[i]];
                      }
                      [self.tableView reloadData];
                  }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *volume = self.comics[indexPath.row];
    NSString *idString = volume[@"id"];
    if ([self.resourceTextField.text isEqualToString:@"Search"]) {
        [self.comicVine volumeForID:idString limit:10 offset:0 completionHandler:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error) {
            NSArray *results = JSON[@"results"][@"issues"];
            self.comics = [NSMutableArray array];
            for (int i = 0; i < [results count]; i++) {
                [self.comics addObject:results[i]];
            }
            self.resourceTextField.text = @"Volume";
//            self.searchTextField.text = idString;
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ComicSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSDictionary *comic = self.comics[indexPath.row];

    NSString *comicID = comic[@"id"];
    NSString *comicName = comic[@"name"];
    cell.textLabel.text = [NSString stringWithFormat:@"(%@) %@",comicID,comicName];

//    NSString *thumbURLString = comic[@"image"][@"thumb_url"];
//    if (thumbURLString) {
//        [cell.imageView setImageWithURL:[NSURL URLWithString:thumbURLString]];
//    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comics count];
}
@end
