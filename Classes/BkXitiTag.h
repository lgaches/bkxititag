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

#import <Foundation/Foundation.h>

/**
 * Enum used by tagAction to send actions to Xiti.
 * Actions are defined with the url parameter "clic"
 */
typedef enum {
	/** Equivalent to "clic='A'" */
	BkXitiTagActionTypeAction,
	
	/** Equivalent to "clic='S'" */
	BkXitiTagActionTypeExit,
	
	/** Equivalent to "clic='N'" */
	BkXitiTagActionTypeNavigation,
	
	/** Equivalent to "clic='T'" */
	BkXitiTagActionTypeDownload
} BkXitiTagActionType;

/**
 * Helper class to send Xiti stats.
 *
 * HOWTO use BkXitiTag:
 *
 *  - BkXitiTag must be initialized before use
 *  [[BkXitiTag sharedXitiTag] xitiTagInitWithXitiSubDomain:@"subdomain_of_xiti_tag" siteId:@"your_website_xiti_id" subsiteId:@"your_subsite_xiti_id"]
 *  - You can call this method in applicationDidFinishLaunching:
 *  - then you can call [[BkXitiTag sharedXitiTag] tagPage:@"name_of_the_page"] or [[BkXitiTag sharedXitiTag] tagAction:@"action_name" ofType:actionType]
 *
 * When tagAction or tagPage is called, a BkXitiTagOperation is created and queued in the NSOperationQueue of BkXitiTag.
 * The operation queue is set to launch one operation at a time.
 * A call to Xiti is then made during the operation with the given parameters + information about the device running the application (see @BkIPhoneInformation for more information about what is sent).
 *
 * @author Thomas Sarlandie
 * @author Philippe Bernery
 * @author François Proulx
 */
@interface BkXitiTag : NSObject {
	NSString *subdomain;
	NSString *siteId;
	NSString *subsiteId;
	NSDictionary *phoneInfos;
	NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) NSString *subdomain;
@property (nonatomic, retain) NSString *siteId;
@property (nonatomic, retain) NSString *subsiteId;
@property (nonatomic, retain) NSDictionary *phoneInfos;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

/**
 * BkXitiTag is a singleton.
 * Access instance of the class with this method.
 */
+ (BkXitiTag *)sharedXitiTag;

/**
 * This method must be called to configure BkXitiTag before any other call.
 *
 * @param subD xiti subdomain. Identifies the server to call for Xiti stats. e.g: http://subd1.xiti.com , subD should be @"subd1"
 * @param siteId id of the site
 * @param subsiteId id of the subsite. Optional.
 */
+ (void) xitiTagInitWithXitiSubDomain:(NSString *)subD siteId:(NSString *)siteId subsiteId:(NSString *)subsiteId; 

/**
 * Call this method to tag a page.
 * @param page name of the page to tag. 'page' will appear in your xiti tag page.
 */
- (void) tagPage:(NSString *)page;

/**
 * Call this method to tag an action.
 * @param action name of the action to tag. 'action' will appear in your xiti tag page.
 */
- (void) tagAction:(NSString *)action ofType:(BkXitiTagActionType)type;

@end
