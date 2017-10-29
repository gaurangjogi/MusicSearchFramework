//
//  MusicSearch_FrameworkTests.m
//  MusicSearch-FrameworkTests
//
//  Created by Gaurang Jogi on 28/10/17.
//  Copyright © 2017 Gaurang Jogi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "JSONBase.h"
#import "UIImageView+LazyImage.h"
#import "ItunesQuery.h"
#import "LyricsQuery.h"
@interface MusicSearch_FrameworkTests : XCTestCase

@end

@interface TestModel:JSONBase
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,copy)   NSString *author;
@property (nonatomic,copy)   NSNumber *prise;
@property (nonatomic,strong) NSString *array;
@end

@implementation TestModel
@dynamic title,author,prise,array;

@end

@implementation MusicSearch_FrameworkTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJSONBaseWithDictionary {
    NSString *sampleJSONString = @"{\"title\":\"test\",\"author\":\"test\",\"prise\":1.2, \"array\":[{\"first\":\"object\"},{\"second\":\"object\"}]}";
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[sampleJSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    TestModel *model = [[TestModel alloc] initWithDictionary:dictionary];
    XCTAssert([model.title isEqualToString:@"test"],@"JSON Base Test Passed for title");
    XCTAssert([model.author isEqualToString:@"test"],@"JSON Base Test Passed for author");
    XCTAssert(model.prise!=nil,@"JSON Base Test Passed for Prise");
    XCTAssert(model.array!=nil,@"JSON Base");
    
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
- (void) testJSONBaseWithString
{
   
        NSString *sampleJSONString = @"{\"title\":\"test\",\"author\":\"test\",\"prise\":1.2, \"array\":[{\"first\":\"object\"},{\"second\":\"object\"}]}";
     
        TestModel *model = [[TestModel alloc] initWithString:sampleJSONString];
        XCTAssert([model.title isEqualToString:@"test"],@"Title Value should be test");
        XCTAssert([model.author isEqualToString:@"test"],@"Author value should be test");
        XCTAssert(model.prise!=nil,@"prise should not be nil");
        XCTAssert(model.array!=nil,@"array should not be nil");
        
        
    
    
}
- (void) testLazyImage
{
    UIImageView *imageView = [[UIImageView alloc] init];
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Image downloading Category"];

    [imageView setImageWithUrl:@"https://static.pexels.com/photos/34950/pexels-photo.jpg" withSuccessCallBack:^(UIImage *image) {
        if(image!=nil)
        {
            [expectation fulfill];
        }
    }];
    XCTAssert([imageView sessionTask]!=nil,@"Session Data task should be created");
    XCTAssert([imageView activityView]!=nil,@"Activity View should be created ");
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:[NSArray arrayWithObject:expectation] timeout:10000];
}
- (void) testItunesQuery
{
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Itunes Query Servies which downloads the songs based on search term"];
    [[[ItunesQuery alloc] init] getSearchResults:@"Tom waits" withSuccess:^(id result) {
        if(result!=nil)
        {
            [expectation fulfill];
        }
    } withFailure:^(NSError *error) {
        
    }];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:[NSArray arrayWithObject:expectation] timeout:10000];

}
- (void) testLyricsQuery
{
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Lyrics Wikia Service which downloads the lyrics"];
    [[[LyricsQuery alloc] init] searchLyricsWithArtist:@"Tom+Waits" forSong:@"New+Coat+Of+Paint" withSuccessBlock:^(id result) {
        if (result!=nil) {
            [expectation fulfill];
        }
        
    } withFailureBlock:^(NSError *error) {
        
    }];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:[NSArray arrayWithObject:expectation] timeout:10000];
}
@end
