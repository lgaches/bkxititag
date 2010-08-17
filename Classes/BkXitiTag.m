// Copyright 2009 Backelite
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "BkXitiTag.h"

#import "BkIPhoneInformation.h"
#import "BkXitiTagOperation.h"
#import "TargetConditionals.h"

@implementation BkXitiTag

@synthesize operationQueue;
@synthesize subdomain;
@synthesize siteId;
@synthesize subsiteId;
@synthesize phoneInfos;

- (BkXitiTag *) initWithXitiSubDomain:(NSString *)subD siteId:(NSString *)sId subsiteId:(NSString *)subsId {
	if ((self = [super init])) {
		NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		[queue setMaxConcurrentOperationCount:1];
		self.operationQueue = queue;
		[queue release];

		self.subdomain = subD;
		self.siteId = sId;
		self.subsiteId = subsId;
		self.phoneInfos = [BkIPhoneInformation iPhoneInformationDictionary];
	}
	
	return self;
}

- (void) dealloc {
	self.subdomain = nil;
	self.siteId = nil;
	self.subsiteId = nil;
	self.operationQueue = nil;
	self.phoneInfos = nil;
	
	[super dealloc];
}


- (void) launchRequest:(NSString *)toAppend {

#if (!defined(DEBUG) || (defined(DEBUG) && !DEBUG)) && !TARGET_IPHONE_SIMULATOR
	NSMutableString *result = [NSMutableString stringWithFormat:@"http://%@.xiti.com/hit.xiti?s=%@&%@", 
							   subdomain, siteId, [toAppend stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	if (subsiteId) {
		[result appendFormat:@"&s2=%@", subsiteId];
	}

	for (NSString *key in phoneInfos) {
		[result appendFormat:@"&%@=%@", key, [[phoneInfos valueForKey:key] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	}
	
	// Random value to pass cache server
	[result appendFormat:@"&na=%f", [NSDate timeIntervalSinceReferenceDate]];
	////
	
	BkXitiTagOperation *o = [[BkXitiTagOperation alloc] initWithXitiUrl:result];
	[operationQueue addOperation:o];
	[o release];
#endif

}

- (void) tagPage:(NSString*) page {
	[self launchRequest:[NSString stringWithFormat:@"p=%@", page]];
}

- (NSString *) stringForActionType:(BkXitiTagActionType)type {
	NSString *result = @"N";
	
	switch (type) {
		case BkXitiTagActionTypeAction:
			result = @"A";
			break;
		case BkXitiTagActionTypeDownload:
			result = @"T";
			break;
		case BkXitiTagActionTypeExit:
			result = @"S";
			break;
		case BkXitiTagActionTypeNavigation:
			result = @"N";
			break;
	}
	
	return result;
}

- (void) tagAction:(NSString *)action  ofType:(BkXitiTagActionType)type {
	[self launchRequest:[NSString stringWithFormat:@"p=%@&clic='%@'", action, [self stringForActionType:type]]];
}

// Implement a Singleton
// See: http://developer.apple.com/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/chapter_3_section_10.html

static BkXitiTag *singletonXitiTag = nil;

+ (void) xitiTagInitWithXitiSubDomain:(NSString *)subD siteId:(NSString *)sId subsiteId:(NSString *)subsId {
	@synchronized(self)
	{
		singletonXitiTag = [[BkXitiTag alloc] initWithXitiSubDomain:subD siteId:sId subsiteId:subsId];
	}
}

+ (BkXitiTag *)sharedXitiTag
{
    @synchronized(self) {
        if (singletonXitiTag == nil) {
			NSAssert(FALSE, @"Xiti tag must be initialized before use.");
        }
    }
    return singletonXitiTag;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (singletonXitiTag == nil) {
            singletonXitiTag = [super allocWithZone:zone];
            return singletonXitiTag;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released	
}

- (void)release
{
    //do nothing	
}

- (id)autorelease
{
    return self;
}

@end
