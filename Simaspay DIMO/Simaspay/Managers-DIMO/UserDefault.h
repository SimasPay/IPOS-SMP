//
//  UserDefault.h
//  BaseProject
//
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject

//Get object with key from user default
+ (id)objectFromUserDefaultsForKey:(NSString *)key;
    
//Remove object with key from user default
+ (void)removeObjectForKey:(NSString *)key;
    
//save object to user default
+ (void)setObject:(id)obj forKey:(NSString *)key;
//+ (void)clearAllUserDefault;
@end
