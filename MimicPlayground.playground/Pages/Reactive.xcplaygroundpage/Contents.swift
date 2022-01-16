import Foundation

enum Event<T> {
    case next(T)
    case error(Error)
    case completed
}

//MARK: Observer
protocol ObserverProtocol {
    associatedtype T
    
    func on(event: Event<T>)
}

class Observer<T>: ObserverProtocol {
    
    private let handler: (Event<T>) -> Void
    
    init(handler: @escaping (Event<T>) -> Void) {
        self.handler = handler
    }
    
    func on(event: Event<T>) {
        handler(event)
    }
    
}

//MARK: Observable
protocol ObservableProtocol {
    associatedtype T
    
    func subscribe<O: ObserverProtocol>(observer: O) where O.T == T
}

class Observable<T>: ObservableProtocol {
    
    private let generator: (Observer<T>) -> Void
    
    init(generator: @escaping (Observer<T>) -> Void) {
        self.generator = generator
    }
    
    func subscribe<O>(observer: O) where O : ObserverProtocol, T == O.T {
        generator(observer as! Observer<T>)
    }
}

//MARK: Practice
let observable = Observable<Int> { observer in
    observer.on(event: .next(0))
    observer.on(event: .next(1))
    observer.on(event: .next(2))
    observer.on(event: .next(3))
    observer.on(event: .completed)
}

let observer = Observer<Int> { event in
    switch event {
    case .next(let val):
        print(val)
    case .error(let error):
        print(error.localizedDescription)
    case .completed:
        print("completed")
    }
}

observable.subscribe(observer: observer)



