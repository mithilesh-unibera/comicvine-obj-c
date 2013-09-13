//
//  BCComicVineClient.h
//  ComicsCollection
//
//  Created by Bryan Clark on 6/23/13.
//  Copyright (c) 2013 Bryan Clark. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void(^ComicVineCompletionHandler)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error);

@interface BCComicVineClient : AFHTTPClient

extern NSString * const kComicVineBaseURL;

+ (id)sharedComicVineClient;
- (id)initWithBaseURL:(NSURL *)url;

- (void)searchWithQuery:(NSString *)query
                  limit:(NSUInteger)limit
                 offset:(NSUInteger)offset
      completionHandler:(ComicVineCompletionHandler)completionHandler;

- (void)volumeForID:(NSString *)volumeID
              limit:(NSUInteger)limit
             offset:(NSUInteger)offset
        completionHandler:(ComicVineCompletionHandler)completionHandler;

- (void)issueForID:(NSString *)issueID
              limit:(NSUInteger)limit
             offset:(NSUInteger)offset
      completionHandler:(ComicVineCompletionHandler)completionHandler;

@end
