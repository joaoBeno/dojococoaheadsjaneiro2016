//
//  Person.m
//  dojosabado
//
//  Created by Jose Lino Neto on 1/30/16.
//  Copyright © 2016 Construtor. All rights reserved.
//

#import "Person.h"
#import <AFNetworking.h>

#define URL_PERSON @"https://api.mongolab.com/api/1/databases/dojococoaheads/collections/Person?apiKey=B70RhtlkqR3tFQBID9--QH8oxLcVMVNy"
#define URL_PERSON_SORT @"https://api.mongolab.com/api/1/databases/dojococoaheads/collections/Person?s={'Nome':1}&apiKey=B70RhtlkqR3tFQBID9--QH8oxLcVMVNy"

@implementation Person

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"_id": @"Id"
                                                       }];
}

+(void)getPersons:(HandlerSucesso)sucesso falha:(HandlerFalha)falha progresso:(HandlerProgresso)progresso{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSCharacterSet *all = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *finalUrl = [URL_PERSON_SORT stringByAddingPercentEncodingWithAllowedCharacters:all];
    
    
    [manager GET:finalUrl
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            progresso(downloadProgress.fractionCompleted);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *erro;
            NSArray *vetorRetorno = [Person arrayOfModelsFromDictionaries:responseObject error:&erro];
            
            if (!erro)
            {
                sucesso(task, vetorRetorno);
            }
            else
            {
                falha(task, erro);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            falha(task, error);
        }];
}

+(void)createPerson:(Person *)person sucesso:(HandlerSucesso)sucesso falha:(HandlerFalha)falha{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *dicionario = [person toDictionary];
    
    
    [manager POST:URL_PERSON parameters:dicionario progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucesso(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        falha(task, error);
    }];
    
    
}

+(void)deletePerson:(Person *)person sucesso:(HandlerSucesso)sucesso falha:(HandlerFalha)falha{
    
    
    NSString *url = @"https://api.mongolab.com/api/1/databases/dojococoaheads/collections/Person/";
    NSString *apiKey = @"?apiKey=B70RhtlkqR3tFQBID9--QH8oxLcVMVNy";
    
    NSString *finalUrl = [url stringByAppendingString:person.Id.Id];
    finalUrl = [finalUrl stringByAppendingString:apiKey];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager DELETE:finalUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        sucesso(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        falha(task, error);
    }];

}










































@end
