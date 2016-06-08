//
//  NSURLRequest+SSLValidation.h
//  Uangku
//
//  Created by RAND on 10/21/13.
//  Copyright (c) 2013 Mfino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (SSLValidation)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;

@end
