//
//  KeyValueStorageTests.swift
//  KeyValueStorageTests
//
//  Created by Alexey Sidorov on 05.04.2022.
//

import XCTest

class StorageManagerTests: XCTestCase {
  
  private var manager: StorageManager?
  
  override func setUpWithError() throws {
    manager = StorageManager(storage: Storage<String, String>())
  }

  override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testSingleSet() throws {
    _ = manager?.input(command: .set(key: "1", value: "aa"))
    let el = manager?.storage.all().first
    XCTAssert(el?.key == "1")
    XCTAssert(el?.value == "aa")
  }
  
  func testSingleGet() throws {
    manager?.storage.put(key: "1", value: "aa")
    let res = manager?.input(command: .get(key: "1"))
    XCTAssert(.success("aa") == (res ?? .failure(.noKey)))
  }
  
  func testDelete() throws {
    manager?.storage.put(key: "1", value: "aa")
    _ = manager?.input(command: .delete(key: "1"))
    let el = manager?.storage.all()
    XCTAssert(el?.isEmpty ?? true)
  }
  
  func testCount() throws {
    manager?.storage.put(key: "1", value: "aa")
    manager?.storage.put(key: "2", value: "aa")
    manager?.storage.put(key: "3", value: "aa")
    manager?.storage.put(key: "4", value: "bb")
    manager?.storage.put(key: "5", value: "bb")
    let res = manager?.input(command: .count(key: "aa")) ?? .failure(.unknown)
    let res1 = manager?.input(command: .count(key: "bb")) ?? .failure(.unknown)
    XCTAssert(.success("3") == res)
    XCTAssert(.success("2") == res1)
  }
  
  func testCountWithTransactions() throws {
    manager?.storage.put(key: "1", value: "aa")
    manager?.storage.put(key: "2", value: "aa")
    manager?.storage.put(key: "3", value: "aa")
    manager?.storage.put(key: "4", value: "bb")
    manager?.storage.put(key: "5", value: "bb")
    _ = manager?.input(command: .begin)
    _ = manager?.input(command: .set(key: "6", value: "aa"))
    _ = manager?.input(command: .begin)
    _ = manager?.input(command: .set(key: "7", value: "aa"))
    
    let res = manager?.input(command: .count(key: "aa")) ?? .failure(.unknown)
    let res1 = manager?.input(command: .count(key: "bb")) ?? .failure(.unknown)
    XCTAssert(.success("5") == res)
    XCTAssert(.success("2") == res1)
  }

  func testCommitTransactions() throws {
    manager?.storage.put(key: "1", value: "aa")
    _ = manager?.input(command: .begin)
    _ = manager?.input(command: .set(key: "1", value: "bb"))
    _ = manager?.input(command: .commit)
    let el = manager?.storage.all().first
    XCTAssert(el?.key == "1")
    XCTAssert(el?.value == "bb")
  }

  func testRollbackTransactions() throws {
    manager?.storage.put(key: "1", value: "aa")
    _ = manager?.input(command: .begin)
    _ = manager?.input(command: .set(key: "1", value: "bb"))
    let res = manager?.input(command: .get(key: "1")) ?? .failure(.unknown)
    XCTAssert(.success("bb") == res)
    _ = manager?.input(command: .rollback)
    let el = manager?.storage.all().first
    XCTAssert(el?.key == "1")
    XCTAssert(el?.value == "aa")
  }

  func testNestedTransactions() throws {
    manager?.storage.put(key: "foo", value: "123")
    _ = manager?.input(command: .begin)
    _ = manager?.input(command: .set(key: "foo", value: "456"))
    let res = manager?.input(command: .get(key: "foo")) ?? .failure(.unknown)
    XCTAssert(.success("456") == res)
    _ = manager?.input(command: .begin)
    _ = manager?.input(command: .set(key: "foo", value: "789"))
    let res1 = manager?.input(command: .get(key: "foo")) ?? .failure(.unknown)
    XCTAssert(.success("789") == res1)
    _ = manager?.input(command: .rollback)
    
    let res2 = manager?.input(command: .get(key: "foo")) ?? .failure(.unknown)
    XCTAssert(.success("456") == res2)
    _ = manager?.input(command: .rollback)
    let res3 = manager?.input(command: .get(key: "foo")) ?? .failure(.unknown)
    XCTAssert(.success("123") == res3)
  }

}
