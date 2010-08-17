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

#import "BkIPhoneInformation.h"

#import "BkXitiReachability.h"

#import <UIKit/UIKit.h>

@implementation BkIPhoneInformation

+ (NSString *) removeSpaces:(NSString *)str {
	NSMutableString *buffer = [NSMutableString stringWithString:str];
	
	// Removes spaces
	[buffer replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
	
	// Lower characters
	return [NSString stringWithString:buffer];
}

+ (NSDictionary *) iPhoneInformationDictionary {
	NSMutableDictionary *buffer = [NSMutableDictionary dictionary];
	
	// Current locale 
	[buffer setValue:[self removeSpaces:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLocale"]] forKey:@"lng"];
	
	// Device model (iphone/ipodtouch)
	[buffer setValue:[self removeSpaces:[UIDevice currentDevice].model] forKey:@"mdl"];
	
	// OS name + version (e.g. iphone-2.2)
	[buffer setValue:[NSString stringWithFormat:@"[%@]-[%@]", 
					  [self removeSpaces:[UIDevice currentDevice].systemName], 
					  [UIDevice currentDevice].systemVersion] 
			  forKey:@"os"];
	
	// Network connection type (Wifi/GSM)
	NSString *connectionType = nil;
	NetworkStatus status = [[BkXitiReachability sharedReachability] internetConnectionStatus];
	if (status == ReachableViaWiFiNetwork) {
		connectionType = @"wifi";
	} else if (status == ReachableViaCarrierDataNetwork) {
		connectionType = @"gsm";
	}
	
	if (connectionType) {
		[buffer setValue:connectionType forKey:@"cn"];
	}
	
	// Application version
	NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
	[buffer setValue:[NSString stringWithFormat:@"[%@]", [infoDict objectForKey:@"CFBundleVersion"]] forKey:@"apvr"];
	
	// Unique identifier (must be 12 characters long)
	NSString *idClient = [UIDevice currentDevice].uniqueIdentifier;
	if (idClient) {
		[buffer setValue:[idClient substringToIndex:12] forKey:@"idclient"];
	}
	
	return [NSDictionary dictionaryWithDictionary:buffer];
}

@end
