//
//  ObjectId.h
//  mongoclientios
//
//  Created by Jose Lino Neto on 1/2/16.
//  Copyright © 2016 Construtor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface ObjectId : JSONModel

@property (strong, nonatomic) NSString *Id;

@end
