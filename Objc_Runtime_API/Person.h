//
//  Person.h
//  Objc_Runtime_API
//
//  Created by 张昭 on 16/5/16.
//  Copyright © 2016年 张昭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    
    NSString *name;
    
    __weak id ivar0;
    __strong id ivar1;
    __unsafe_unretained id ivar2;
    __weak id ivar3;
    __strong id ivar4;
    
//    NSInteger age;
}

@property (nonatomic, assign) NSInteger age;



@end
