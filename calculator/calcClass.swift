//
//  calcClass.swift
//  calculator
//
//  Created by Pranav Shashikant Deshpande on 7/5/17.
//  Copyright © 2017 Pranav Shashikant Deshpande. All rights reserved.
//

import Foundation


enum CalcError: Error {
    case DivideByZero
}

struct CalculatorBrain {
    
    
    private var accumulator: Double?
   
    private enum Operation {
        
        case binary((Double,Double) -> Double)
        case equals
    }
    
    // private extensible dictionary of operations with closures
    private var operations: Dictionary<String,Operation> = [
        
        "×" : Operation.binary({ $0 * $1 }),
        "÷" : Operation.binary({ $0 / $1 }),
        "+" : Operation.binary({ $0 + $1 }),
        "−" : Operation.binary({ $0 - $1 }),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .binary(let f):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    // Private mutating func for performing pending binary operations
    mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
   
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}

