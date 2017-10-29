//
//  UIImageView+LazyImage.h
//  MusicSearch-Framework
//
//  Created by Gaurang Jogi on 28/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ImageDownloadSuccess)(UIImage *image);
/**
 * Usage : UIImageView Extension Category which allows you to load Image asychronously anywhere
 * Enhancement can be made :Here image caching can be improved using disk caching but as off now it is implemented in memory
 *                          cache. By using disk caching we can avoid memory warning in case we have lot of images.
 */
@interface UIImageView (LazyImage)
/**
 * Function: setImageWithUrl function will download image and assign it to image property automatically caching it also. So when you try to set the
 * same url it will take image from cache.
 * @param url : The url from where image needs to get downloaded
 */
- (void) setImageWithUrl:(NSString*)url;
/**
 * For testing LazyImage creating this it might be use full if image need not to be cached
 */
- (void) setImageWithUrl:(NSString*)url withSuccessCallBack:(ImageDownloadSuccess)success;
/**
 * Function Name : setFreeCacheOnMemoryWarning.
 * @param freeCacheOnMemoryWarning :  pass YES if you want to clear memory on memory warning
 */
+ (void)setFreeCacheOnMemoryWarning:(BOOL)freeCacheOnMemoryWarning;

/**
 * For testing whether sessionTask is getting created or not
 */
- (NSURLSessionDataTask*) sessionTask;

/**
 * For testing whether activity indicator is getting created or not
 */
- (UIActivityIndicatorView*) activityView;
@end
