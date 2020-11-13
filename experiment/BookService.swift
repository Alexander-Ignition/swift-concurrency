//
//  BookService.swift
//  experiment
//
//  Created by Alexander Igantev on 11/12/20.
//

import Foundation
import Combine

struct Book: Identifiable, Codable {
    let id: Int
    let name: String
}

final class BookService {

    func books(completion: @escaping ([Book]) -> Void) {
        let book = Book(id: 1, name: "Any Book")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion([book])
        }
    }
    
    func book(by id: Book.ID, completion: @escaping (Result<Book, Error>) -> Void) {
        let book = Book(id: id, name: "Any Book")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(book))
        }
    }
    
    func content(for book: Book, completion: @escaping (Result<String, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success("Hello!"))
        }
    }
}


// MARK: - Callbacks

extension BookService {
    
    func bookContent(by id: Book.ID, completion: @escaping (Result<String, Error>) -> Void) {
        
        book(by: id) { (result0: Result<Book, Error>) in
            switch result0 {
            case .failure(let error):
                completion(.failure(error))
            case .success(let book):
                
                self.content(for: book) { (result1: Result<String, Error>) in
                    switch result1 {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let string):
                        completion(.success(string))
                    }
                }
            }
        }
    }
}


// MARK: - Reactive

extension BookService {
    
    func bookFuture(by id: Book.ID) -> Future<Book, Error> {
        Future { promise in
            self.book(by: id, completion: { promise($0) })
        }
    }
    
    func contentFuture(for book: Book) -> Future<String, Error>  {
        Future { promise in
            self.content(for: book, completion: { promise($0) })
        }
    }
    
    func bookContentPublisher(by id: Book.ID) -> AnyPublisher<String, Error> {
        bookFuture(by: id)
            .flatMap { book in
                self.contentFuture(for: book)
            }
            .eraseToAnyPublisher()
    }
}


// MARK: - Async / Await

extension BookService {

    func books() async -> [Book]  {
        await Task.withUnsafeContinuation { (continuation: Task.UnsafeContinuation<[Book]>) in

            self.books { (books: [Book]) in
                continuation.resume(returning: books)
            }
        }
    }
    
    func book(by id: Book.ID) async throws -> Book  {
        await try Task.withUnsafeThrowingContinuation { (continuation: Task.UnsafeThrowingContinuation<Book, Error>) in

            self.book(by: id) { (result: Result<Book, Error>) in
                continuation.resume(result: result)
            }
        }
    }
    
    func content(for book: Book) async throws -> String  {
        await try Task.withUnsafeThrowingContinuation { (continuation: Task.UnsafeThrowingContinuation<String, Error>) in

            self.content(for: book) { (result: Result<String, Error>) in
                continuation.resume(result: result)
            }
        }
    }
    
    func bookContent(by id: Book.ID) async throws -> String  {
        let aBook = await try self.book(by: id)
        let string = await try self.content(for: aBook)
        return string
    }

    func execute() async -> Result<Int, Error> {
        await Task.withUnsafeContinuation { continuation in
            continuation.resume(returning: Result<Int, Error>.success(12))
        }
    }
}

extension Task.UnsafeThrowingContinuation {
    func resume(result: Result<T, E>) {
        switch result {
        case .failure(let error):
            resume(throwing: error)
        case .success(let book):
            resume(returning: book)
        }
    }
}


// MARK: - Interoperability with Objective-C

func downloadBook() async throws -> [Book] {
    let url = URL(string: "https://example.com/api/books")!
    let downloader = Downloader()
    let data = await try downloader.download(with: url)
    let books = try JSONDecoder().decode([Book].self, from: data)
    return books
}

final class NewDownloader: NSObject {
    /* @objc */ func download(with url: URL) async throws -> Data? {
        fatalError()
    }
}

// MARK: - Cancel

//func downloadBookAndCancel() {
//    let service = BookService()
//
//    let task = Task.runDetached {
//        await try service.bookContent(by: 1)
//    }
//
//    // on tap
//    task.cancel()
//}


// MARK: - Parallel

//extension BookService {
//
//    func downloadBooks(ids: [Book.ID]) async throws -> [Book] {
//
//        await try Task.withGroup(resultType: [Book].self) { group in
//            var books: [Book] = ids.map { _ in Book(id: 0, name: "") }
//
//            for i in ids.indices {
//                await try group.add {
//                    let book = await self.book(by: ids[i])
//                    return (i, book)
//                }
//            }
//
//            while let (index, book) = await try group.next() {
//                books[index] = book
//            }
//            return books
//        }
//    }
//}


// MARK: - Actor

actor class AccountActor {
    var account = 1_000

    func run(message: String) async {
        account = await load()
    }

    func load() async -> Int {
        fatalError()
    }
}

//final class BookView {
//    let id: Book.ID = 1
//    let bookService = BookService()
//
//    func refresh() {
//        Task.runDetached {
//            // 1
//            let book = await try bookService.book(by: id)
//            // 2
//            show(book)
//        }
//    }
//
//    @UIActor
//    func show(_ book: Book) {
//        //
//    }
//}
