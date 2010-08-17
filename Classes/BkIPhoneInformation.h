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

@interface BkIPhoneInformation : NSObject {

}

/**
 * Retrieves some information to be sent to Xiti and put it in 
 * a dictionary.
 * keys:
 *  - lng : locale (fr_fr, en)
 *  - mdl : model (iPhone/iPodTouch)
 *  - os  : name-version ([iphone]-[2.2])
 *  - tc  : network type (wifi/gsm)
 *  - apvr : application version (e.g. [1.0])
 *  - idclient : uniqueIdentifier from UIDevice
 */
+ (NSDictionary *) iPhoneInformationDictionary;

@end
