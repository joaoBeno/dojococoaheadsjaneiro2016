//
//  Person.m
//  dojosabado
//
//  Created by Jose Lino Neto on 1/30/16.
//  Copyright © 2016 Construtor. All rights reserved.
//

#import "Person.h"
#import "constants.h"
#import <AFNetworking.h>

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
    
    [manager GET:[[NSURL URLWithString:@"Person" relativeToURL:[NSURL URLWithString:BASE_URL]] absoluteString]
      parameters: [NSDictionary dictionaryWithObjectsAndKeys:
                   @"{'Nome':1}",@"s",
                   API_KEY,@"apiKey", nil]
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
    
    NSMutableString *url = [NSMutableString stringWithString:@"Person"];
    [url appendString:@"?apiKey="];
    [url appendString:API_KEY];
    
    [manager POST:[[NSURL URLWithString: url
                          relativeToURL:[NSURL URLWithString:BASE_URL]] absoluteString]
       parameters:[NSDictionary dictionaryWithDictionary:dicionario]
         progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucesso(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        falha(task, error);
    }];
    
    
}

+(void)deletePerson:(Person *)person sucesso:(HandlerSucesso)sucesso falha:(HandlerFalha)falha{
    
    
    NSURL *url = [NSURL URLWithString:@"Person/" relativeToURL:[NSURL URLWithString:BASE_URL]];
    NSURL *finalUrl = [NSURL URLWithString:person.Id.Id relativeToURL:url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager DELETE:[finalUrl absoluteString]
         parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                     API_KEY,@"apiKey", nil]
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        sucesso(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        falha(task, error);
    }];

}

+(void)updatePerson:(Person *)person sucesso:(HandlerSucesso)sucesso falha:(HandlerFalha)falha {
    
}










































@end
