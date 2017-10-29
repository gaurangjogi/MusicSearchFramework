//
//  LyricsQuery.m
//  MusicSearch-Framework
//
//  Created by Gaurang Jogi on 29/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import "LyricsQuery.h"
#define LYRICS_WIKIA_APIURL @"http://lyrics.wikia.com/api.php"
#define LYRICS_QUERY_STRING @"func=getSong&artist=%@&song=%@&fmt=json"
@interface LyricsQuery()
@property (nonatomic,strong) NSURLSession *defaultSession;
@property (nonatomic,strong) NSURLSessionDataTask *dataTask;
@end

@implementation LyricsQuery
@synthesize defaultSession,dataTask;
- (instancetype) init
{
    if(self = [super init])
    {
        self.defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        return self;
    }
    return nil;
}
- (void) searchLyricsWithArtist:(NSString*)artist forSong:(NSString*)song withSuccessBlock:(LyricsQueryReturnBlockWithObject)success withFailureBlock:(LyricsQueryReturnBlockWithError)errorCallback
{
    if(self.dataTask!=nil)
    {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:LYRICS_WIKIA_APIURL];
    artist = [artist stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    song = [song stringByReplacingOccurrencesOfString:@" " withString:@"+"] ;
    urlComponent.query = [@"" stringByAppendingFormat:LYRICS_QUERY_STRING,artist,song];
    NSURL *url = [urlComponent URL];
    dataTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error!=nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(error);
            });
        }
        NSError *jsonSerialisationError;
        if(data!=nil)
        {
            /**
             * The return value has valid json but the formate is as below
             * song = { ... }
             * Need to remove Song= from the returned string to allow deserialization into dictionary
             * Another thing is the JSON is not valid because instead of double quotes it has single quotes for JSON
             * Currently handling this as hack for easier implementation
             * We can use XML formate and then parse xml and create dictionary.
             */
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"song =" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"%^"];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\'" withString:@"#$"];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"#$" withString:@"'"];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"%^" withString:@"\\\""];
            id object = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&jsonSerialisationError];
            if(jsonSerialisationError!=nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorCallback(jsonSerialisationError);
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(object);
                });
            }
        }
        else{
            NSLog(@"Data returned is null");
            errorCallback([[NSError alloc] initWithDomain:NSURLErrorFailingURLErrorKey code:303 userInfo:@{NSLocalizedDescriptionKey:@"The data retured is null"}]);
            
        }
    }];
    [dataTask resume];
}
@end
