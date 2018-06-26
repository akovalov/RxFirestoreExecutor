/*
 The MIT License (MIT)
 Copyright (c) 2018 ANODA Mobile Development Agency. http://anoda.mobi <info@anoda.mobi>
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import Foundation
import RxSwift

public class QueryExecutor<Target> where Target: QueryTargetProtocol {
    private var single = ExecutorSingle()
    private var observeable = ExecutorObserveable()
    
    public init() {}
    
    public func request(_ token: Target, condition: QueryConditions = .and) -> Single<Any> {
        single.create(collectionRef: token.collection)
        single.condition = condition
        
        return DispatchQueue.global().sync(execute: { () -> Single<Any> in
            return single.singleTrait(token.singleDocument,
                                      token.params,
                                      token.data)
                .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
                .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
        })
    }
    
    public func subscribe(_ token: Target, condition: QueryConditions = .and) -> Observable<Any> {
        observeable.create(collectionRef: token.collection)
        observeable.condition = condition
        
        return DispatchQueue.global().sync(execute: { () -> Observable<Any> in
            return observeable.observableSubscription(token.singleDocument,
                                                      token.params,
                                                      token.nestedCollection)
                .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
                .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .utility))
        })
        
    }
}


