//
//  Person.h
//  dojosabado
//
//  Created by Jose Lino Neto on 1/30/16.
//  Copyright © 2016 Construtor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <JSONModel.h>
#import "ObjectId.h"

@interface Person : JSONModel

@property (strong, nonatomic) ObjectId *Id;
@property (strong, nonatomic) NSString *Nome;
@property (strong, nonatomic) NSString *Email;

typedef void (^HandlerSucesso)(NSURLSessionDataTask *resposta, NSArray *objetoDeResposta);
typedef void (^HandlerFalha)(NSURLSessionDataTask *resposta, NSError *erro);
typedef void (^HandlerProgresso)(float progresso);

+(void)getPersons:(HandlerSucesso)sucesso falha:(HandlerFalha)falha progresso:(HandlerProgresso)progresso;

/**
 *  Metodo para Criar Pessoa
 *
 *  @param person  Person a ser criada
 *  @param sucesso bloco de sucesso
 *  @param falha   bloco de erro
 */
+(void)createPerson:(Person *)person sucesso:(HandlerSucesso)sucesso falha:(HandlerFalha)falha;

+(void)updatePerson:(Person *)person sucesso:(HandlerSucesso)sucesso falha:(HandlerFalha)falha;

+(void)deletePerson:(Person *)person sucesso:(HandlerSucesso)sucesso falha:(HandlerFalha)falha;

@end
