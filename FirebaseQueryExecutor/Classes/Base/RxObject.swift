//
//  RxObject.swift
//  BoringSSL
//
//  Created by Pavel Mosunov on 10/3/18.
//

import Foundation
import RxSwift

open class RxObject: FEObject, SelfExecutable {
    
    public typealias ObjectType = RxObject
    
    open func pull() -> Single<RxObject> {
        return super.pull()
    }

    open func push(_ object: RxObject) -> Single<RxObject> {
        return super.push(object)
    }

    open func observe() -> Observable<RxObject> {
        return super.observe()
    }
    
    public func cast<ObjType: RxObject>(data: RxObject) -> ObjType {
        var obj: ObjType = ObjType([:])
        if let dataModel = data as? ObjType {
            obj = dataModel
        }
        return obj
    }
}
