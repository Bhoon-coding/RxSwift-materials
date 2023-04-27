import Foundation
import RxSwift

//example(of: "just, of, from") {
//    // 1
//    let one = 1
//    let two = 2
//    let three = 3
//
//    // 2
//    let observable = Observable<Int>.just(one)
//
//    let observable2 = Observable.of(one, two, three)
//}

// MARK: - subscribe
//example(of: "subscribe") {
//    let one = 1
//    let two = 2
//    let three = 3
//
//    let observable = Observable.of(one, two, three)
//    observable.subscribe { event in
//
//        if let element = event.element {
//            print(element)
//        }
//    }
//}
//
// MARK: - empty
///// 값이 없을때 observable을 바로 Return (complete호출)
//example(of: "empty") {
//    let observable = Observable<Void>.empty()
//
//    observable.subscribe(onNext: { element in
//        print(element)
//    }, onCompleted: {
//        print("Completed")
//    }
//    )
//}

// MARK: - never
///// empty와 반대 개념 (아무것도 방출하지않음 complete도)
//example(of: "never") {
//    let observable = Observable<Void>.never()
//
//    observable.subscribe(onNext: { element in
//        print(element)
//    }, onCompleted: {
//        print("Completed")
//    }
//    )
//}

// MARK: - range
//example(of: "range") {
//    // 1
//    let observable = Observable<Int>.range(start: 1, count: 10)
//
//    observable.subscribe(onNext: { i in
//        // 2
//        let n = Double(i)
//
//        let fibonacci = Int(
//            ((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded()
//        )
//
//        print(fibonacci)
//    }
//    )
//}

// MARK: - Dispose
//example(of: "dispose") {
//    // 1
//    let observable = Observable.of("A", "B", "C")
//
//    // 2
//    let subscription = observable.subscribe { event in
//        // 3
//        print(event)
//    }
//
//    subscription.dispose()
//}

// MARK: - DisposeBag
//example(of: "DisposeBag") {
//    // 1
//    let disposeBag = DisposeBag()
//
//    // 2
//    Observable.of("A", "B", "C")
//        .subscribe { // 3
//            print($0)
//        }
//        .disposed(by: disposeBag) // 4
//}

// MARK: - create
//example(of: "create") {
//
//    enum MyError: Error {
//        case anError
//    }
//
//    let disposeBag = DisposeBag()
//
//    Observable<String>.create { observer in
//        // 1 - 방출하고
//        observer.onNext("1")
//
////        observer.onError(MyError.anError)
//
//        // 2 - 끝나고
////        observer.onCompleted()
//
//        // 3 - 끝났으니까 넘어가고
//        observer.onNext("?")
//
//        // 4 - dispose 호출
//        return Disposables.create()
//    }
//    .subscribe(onNext: { print($0) },
//               onError: { print($0) },
//               onCompleted: { print("Completed") },
//               onDisposed: { print("Disposed") }
//    )
//    .disposed(by: disposeBag) /// dispose를 안해주면 observable이 계속해서 돌아가고 있어 memory leak이 발생함.
//}

// MARK: - deferred
//example(of: "deferred") {
//    let disposeBag = DisposeBag()
//
//    // 1
//    var flip = false
//
//    // 2
//    let factory: Observable<Int> = Observable.deferred {
//
//        // 3
//        flip.toggle()
//
//        // 4
//        if flip {
//            return Observable.of(1, 2, 3)
//        } else {
//            return Observable.of(4, 5, 6)
//        }
//    }
//
//    for _ in 0...4 {
//        factory.subscribe(onNext: {
//            print($0, terminator: "")
//        })
//        .disposed(by: disposeBag)
//
//        print()
//    }
//}

// MARK: - Single
example(of: "Single") {
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    func loadText(from name: String) -> Single<String> {
        return Single.create { single in
            // create시 disposable을 해줘야함 (create 옵션+클릭)
            let disposable = Disposables.create()
            
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            
            single(.success(contents))
            return disposable
        }
    }
    
    loadText(from: "Copyright")
        .subscribe {
            switch $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
}


