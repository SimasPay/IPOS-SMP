//
//  UserDefault.h
//  BaseProject
//
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject
+ (id)objectFromUserDefaultsForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;
+ (void)setObject:(id)obj forKey:(NSString *)key;
//+ (void)clearAllUserDefault;
@end
