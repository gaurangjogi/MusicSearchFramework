//
//  LyricsQuery.h
//  MusicSearch-Framework
//
//  Created by Gaurang Jogi on 29/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *Itunes Query Sucess and failure callbacks defination
 */
typedef void (^LyricsQueryReturnBlockWithObject)(id result);
typedef void (^LyricsQueryReturnBlockWithError)(NSError *error);
/**
 * LyricsQuery
 * Usage : This class is used to retrive lyrics from lyrics wikia.
 */
@interface LyricsQuery : NSObject

/**
 * Function :  searchLyricsWithArtist
 * @param  artist of the song
 * @param  song   partial lyrics of the song
 * @param  success code block which returns the lyrics object
 * @param  errorCallback code block in case the service fails to retrive.
 */
- (void) searchLyricsWithArtist:(NSString*)artist forSong:(NSString*)song withSuccessBlock:(LyricsQueryReturnBlockWithObject)success withFailureBlock:(LyricsQueryReturnBlockWithError)errorCallback;
@end
