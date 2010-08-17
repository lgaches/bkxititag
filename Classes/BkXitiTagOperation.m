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

#import "BkXitiTagOperation.h"

#import "BkIPhoneInformation.h"

@implementation BkXitiTagOperation

@synthesize xitiUrl;

- (BkXitiTagOperation *) initWithXitiUrl:(NSString *)url
{
	if ((self = [super init]))
	{
		self.xitiUrl = url;
		[self setQueuePriority:NSOperationQueuePriorityLow];
	}
	
	return self;
}

- (void) dealloc {
	[xitiUrl release];
	
	[super dealloc];
}

- (void) main
{
	NSURL *url = [NSURL URLWithString:xitiUrl];
	
	if (url != nil)
	{
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url 
															   cachePolicy:NSURLRequestReloadIgnoringCacheData 
														   timeoutInterval:3];
		// Generating a user-agent
		NSDictionary *info = [BkIPhoneInformation iPhoneInformationDictionary];
		NSString *userAgent = [NSString stringWithFormat:@"BkXiti/1.0 (%@; %@; %@)", 
							   [info objectForKey:@"mdl"],
							   [info objectForKey:@"os"],
							   [info objectForKey:@"lng"]];
		
		[request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		#if defined(DEBUG)
			NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
			if (data != nil)
			{
				NSLog(@"Xiti tag: %@ ok", xitiUrl);
			}
			else {
				if (error != nil)
					NSLog(@"Error tagging: %@ - %@", xitiUrl, [error localizedDescription]);
				else
					NSLog(@"Error tagging: %@ - (error = null)", xitiUrl);
			}
		#else
			[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		#endif
	}
#if defined(DEBUG)
	else {
		NSLog(@"Error parsing url: %@", xitiUrl);
	}
#endif
}

@end
