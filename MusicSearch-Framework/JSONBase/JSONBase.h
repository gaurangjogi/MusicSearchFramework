//
//  JSONBase.h
//  MusicSearch-Framework
//
//  Created by Gaurang Jogi on 28/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Usage :JSONBase a generic class which can be subclassed and add properties to read from the dictionary.
 *        When subclassed create dynamic properties.
 * Current State of development : Currently this class maps with dictionary with same keyname in dictionary as name of property in model
 *                                class.
 * Letter Enhancement : But to make more useful we can have keymapper which can map keys of dictionary with name of property in model class.
 */
@interface JSONBase : NSObject
/**
 * Initialise object with Dictionary
 */
-(instancetype) initWithDictionary:(NSDictionary*)dictionary;
/**
 * Initialise object with Jsonstring. JSONString should be valid. Basic validation is done in this but further need to check.
 */
-(instancetype) initWithString:(NSString*)string;
@end
