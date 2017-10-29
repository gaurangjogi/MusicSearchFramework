//
//  ItunesQuery.h
//  MusicSearch-Framework
//
//  Created by Gaurang Jogi on 28/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *Itunes Query Sucess and failure callbacks defination
 */
typedef void (^ItunesQueryReturnBlockWithObject)(id result);
typedef void (^ItunesQueryReturnBlockWithError)(NSError *error);

/**
 * Usage :Itunes Query provides search mechanisam in iTunes music songs
 * Enhancement :generic search service but need more time to create general search service. Need some more time to create general search
 *              service
 *              Name of the class should be QueryService.
 *              There should be property for searchURL and the query parameter where searchTerm needs to pass.
 *              Need to have parameter like HTTPMethod alos incase it is post service
 */

@interface ItunesQuery : NSObject
/**
 *getSearchResults returns search result based on searchTerm defined
 *Accepts following parameter
 *@param searchTerm It is self explainatory searching Ituens based on searchTerm provided
 *@param successCallBack Method returns data with this callback method.
 *@param failureCallback InCass of failure this callback will be invoked.
 */
- (void) getSearchResults:(NSString*) searchTerm withSuccess:(ItunesQueryReturnBlockWithObject)successCallBack withFailure:(ItunesQueryReturnBlockWithError)failureCallback;

@end
