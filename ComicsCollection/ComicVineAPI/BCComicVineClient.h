//
//  BCComicVineClient.h
//  ComicsCollection
//
//  Created by Bryan Clark on 6/23/13.
//  Copyright (c) 2013 Bryan Clark. All rights reserved.
//

#import "AFHTTPClient.h"

@interface BCComicVineClient : AFHTTPClient

extern NSString * const kComicVineBaseURL;

+ (id)sharedComicVineClient;
- (id)initWithBaseURL:(NSURL *)url;

- (void)searchWithQuery:(NSString *)query
                  limit:(NSUInteger)limit
                 offset:(NSUInteger)offset
      completionHandler:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error))completionHandler;

- (void)issuesWithName:(NSString *)name
                 limit:(NSUInteger)limit
                offset:(NSUInteger)offset
     completionHandler:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error))completionHandler;

@end
