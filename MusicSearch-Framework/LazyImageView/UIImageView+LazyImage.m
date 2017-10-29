//
//  UIImageView+LazyImage.m
//  MusicSearch-Framework
//
//  Created by Gaurang Jogi on 28/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import "UIImageView+LazyImage.h"
#import <objc/runtime.h>
static NSMutableDictionary *_cache;
static BOOL _freeCacheOnMemoryWarning;
static void *SessionDataTask;
static void *ImageDownloadingActivity;
@implementation UIImageView (LazyImage)
- (void) setImageWithUrl:(NSString*)url withSuccessCallBack:(ImageDownloadSuccess)success
{
    // Trying to retrive Image from cache
    if([_cache objectForKey:url]!=nil)
    {
        self.image = [_cache objectForKey:[url stringByAppendingFormat:@"%f,%f",self.frame.size.width,self.frame.size.height]];
        return;
    }
    // If Image is not available in cache then try to get previous sessionTask if it is available and cancel the task
    NSURLSessionDataTask *sessionDataTask = [self sessionTask];
    if(sessionDataTask != nil)
    {
        [sessionDataTask cancel];
        objc_setAssociatedObject(self, &SessionDataTask, NULL, OBJC_ASSOCIATION_RETAIN);
        sessionDataTask = nil;
    }
    self.image = nil;
    // Start Activity Indicatory
    [[self activityView] startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    // create an session data task to obtain and download the icon
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                            
                                                                            
                                                                            
                                                                            
                                                                            if (error != nil)
                                                                            {
                                                                                if (@available(iOS 9.0, *)) {
                                                                                    if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                                                    {
                                                                                        // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                                                        // then your Info.plist has not been properly configured to match the target server.
                                                                                        //
                                                                                        abort();
                                                                                    }
                                                                                }
                                                                                else {
                                                                                    // Fallback on earlier versions
                                                                                }
                                                                            }
                                                                            
                                                                            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                                                
                                                                                // Set appIcon and clear temporary data/image
                                                                                UIImage *image = [[UIImage alloc] initWithData:data];
                                                                                success(image);
                                                                                
                                                                                
                                                                                
                                                                            }];
                                                                        }];
    
    [sessionTask resume];
    /// Set the sessionTask and to retrive it later to cancel if another image starts downloading.
    objc_setAssociatedObject(self, &SessionDataTask, sessionTask, OBJC_ASSOCIATION_RETAIN);
}
- (void) setImageWithUrl:(NSString*)url
{
    __block UIImageView *bself = self;
    [self setImageWithUrl:url withSuccessCallBack:^(UIImage *image) {
        if(image!=nil)
        {
            if (image.size.width != bself.frame.size.width || image.size.height != bself.frame.size.height)
            {
                CGSize itemSize = CGSizeMake(bself.frame.size.width, bself.frame.size.height);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [image drawInRect:imageRect];
                bself.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else
            {
                bself.image = image;
            }
            if(_cache==nil)
            {
                _cache = NSMutableDictionary.new;
            }
            /// After assigning image stop activity indicator
            [[bself activityView] stopAnimating];
            /// Set the image
            [_cache setObject:image forKey:[url stringByAppendingFormat:@"%f,%f",bself.frame.size.width,bself.frame.size.height]];
        }
        
    }];
}
- (NSURLSessionDataTask*) sessionTask
{
    NSURLSessionDataTask *sessionTask = objc_getAssociatedObject(self, &SessionDataTask);
    return sessionTask;
}
- (UIActivityIndicatorView*) activityView
{
    /// Creating activity indicator view for each image.
    UIActivityIndicatorView *activityIndicatoryView = objc_getAssociatedObject(self, &ImageDownloadingActivity);
    if(activityIndicatoryView == nil)
    {
        activityIndicatoryView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatoryView.hidesWhenStopped = YES;
        activityIndicatoryView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:activityIndicatoryView];
        objc_setAssociatedObject(self, &ImageDownloadingActivity, activityIndicatoryView, OBJC_ASSOCIATION_RETAIN);
    }
    return activityIndicatoryView;
    
}
+ (BOOL)freeCacheOnMemoryWarning {
    
    return _freeCacheOnMemoryWarning;
}
+ (void)freeCache {
    
    NSLog(@"[UIImageView+LazyImage freeCache]:\n%@", _cache);
    if([self freeCacheOnMemoryWarning]==YES)
    _cache = nil;
}

+ (void)setFreeCacheOnMemoryWarning:(BOOL)freeCacheOnMemoryWarning {
    
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    if (freeCacheOnMemoryWarning) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(freeCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    _freeCacheOnMemoryWarning = freeCacheOnMemoryWarning;
}
@end
