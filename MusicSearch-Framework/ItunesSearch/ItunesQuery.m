//
//  ItunesQuery.m
//  MusicSearch-Framework
//
//  Created by Gaurang Jogi on 28/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import "ItunesQuery.h"

#define ITUNES_SEARCH_API_URL @"https://itunes.apple.com/search"
#define ITUNES_SEARCH_QUERY_STRING_PARAMETER @"media=music&entity=song&term="
@interface ItunesQuery()

@property (nonatomic,strong) NSURLSession *defaultSession;
@property (nonatomic,strong) NSURLSessionDataTask *dataTask;


@end

@implementation ItunesQuery
@synthesize defaultSession,dataTask;

- (instancetype) init
{
    if(self = [super init])
    {
        defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
        return self;
    }
    return nil;
}
/**
 * this could be further enhanced to general search service.
 * 
 */
- (void) getSearchResults:(NSString*) searchTerm withSuccess:(ItunesQueryReturnBlockWithObject)successCallBack withFailure:(ItunesQueryReturnBlockWithError)failureCallback
{
    if(dataTask!=nil)
    {
       [dataTask cancel];
        dataTask = nil;
    }
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:ITUNES_SEARCH_API_URL];
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    urlComponent.query = [ITUNES_SEARCH_QUERY_STRING_PARAMETER stringByAppendingFormat:@"%@",searchTerm];
    NSURL *url = [urlComponent URL];
    dataTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error!=nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureCallback(error);
            });
        }
        NSError *jsonSerialisationError;
        if(data!=nil)
        {
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonSerialisationError];
            if(jsonSerialisationError!=nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureCallback(jsonSerialisationError);
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    successCallBack(object);
                });
            }
        }
        else{
            NSLog(@"Data returned is null");
            failureCallback([[NSError alloc] initWithDomain:NSURLErrorFailingURLErrorKey code:303 userInfo:@{NSLocalizedDescriptionKey:@"The data retured is null"}]);
            
        }
    }];
    [dataTask resume];
}
@end
