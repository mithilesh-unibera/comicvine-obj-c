//
//  BCComicVineClient.m
//  ComicsCollection
//
//  Created by Bryan Clark on 6/23/13.
//  Copyright (c) 2013 Bryan Clark. All rights reserved.
//

#import "BCComicVineClient.h"
#import "BCConstants.h"


@implementation BCComicVineClient

NSString * const kComicVineBaseURL = @"http://www.comicvine.com/api";

+ (id)sharedComicVineClient
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@",kComicVineBaseURL];
    
    static dispatch_once_t onceQueue;
    static BCComicVineClient *comicVineClient = nil;
    
    dispatch_once(&onceQueue, ^{ comicVineClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:urlString]]; });
    return comicVineClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"text/html"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    return self;
}

- (NSURL *)urlForResource:(NSString *)resource andParameters:(NSDictionary *)params
{
    NSURL *url = nil;
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@/?api_key=%@&format=%@",kComicVineBaseURL,resource,COMIC_VINE_API_KEY,COMIC_VINE_RESPONSE_FORMAT];
    for (NSString *paramName in [params allKeys]) {
        NSString *paramValueString = nil;
        id paramValue = params[paramName];
        if ([paramValue isKindOfClass:[NSNumber class]]) {
            NSNumber *paramValueNumber = (NSNumber *)paramValue;
            paramValueString = [paramValueNumber stringValue];
        } else {
            // assume it's a string
            paramValueString = (NSString *)paramValue;
        }
        NSString *param = [NSString stringWithFormat:@"&%@=%@",paramName,[paramValueString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [urlString appendString:param];
    }
    NSLog(@"url: %@",urlString);
    url = [NSURL URLWithString:urlString];
    return url;
}

- (void)requestWithURL:(NSURL *)url andCompletionHandler:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionHandler(request,response,JSON,nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completionHandler(request,response,JSON,error);
    }];
    [op start];    
}

- (void)searchWithQuery:(NSString *)query limit:(NSUInteger)limit offset:(NSUInteger)offset completionHandler:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error))completionHandler
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"query"] = query;
    if (limit > 0) {
        params[@"limit"] = [NSNumber numberWithInteger:limit];
    }
    if (offset > 0) {
        params[@"offset"] = [NSNumber numberWithInteger:offset];
    }
    NSURL *url = [self urlForResource:@"search" andParameters:params];
    [self requestWithURL:url andCompletionHandler:completionHandler];
}

- (void)issuesWithName:(NSString *)name
                 limit:(NSUInteger)limit
                offset:(NSUInteger)offset
     completionHandler:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSError *error))completionHandler;
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"query"] = name;
    if (limit > 0) {
        params[@"limit"] = [NSNumber numberWithInteger:limit];
    }
    if (offset > 0) {
        params[@"offset"] = [NSNumber numberWithInteger:offset];
    }
    NSURL *url = [self urlForResource:@"issues" andParameters:params];
    [self requestWithURL:url andCompletionHandler:completionHandler];
}
@end
