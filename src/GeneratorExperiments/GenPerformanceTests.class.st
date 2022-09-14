"
I perform a number of different performance tests on the five generator implementations
"
Class {
	#name : #GenPerformanceTests,
	#superclass : #Object,
	#category : #'GeneratorExperiments-Performance'
}

{ #category : #subjects }
GenPerformanceTests >> generators [
	^ { GenGenerator. GenSimpleGenerator. ProcessSemaphoreGenerator. ProcessSuspendGenerator. Generator}.
	
]

{ #category : #performance }
GenPerformanceTests >> performMeasurementNumbers [
	| primesBody timer |
	primesBody := [ :gen | 
		(1 to: 100) do: [ :i | gen yield: i ] ].
	timer := GenExperimentTimer new
		blockReps: 1;
		measureReps: 500.
	^ self generators collect: [ :generator |
		generator name -> (timer minFor: [ | gen |
			gen := generator on: primesBody.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]
]

{ #category : #performance }
GenPerformanceTests >> performMeasurementPrimes [
	| primesBody timer |
	primesBody := [ :gen | 
		1000000 to: 1100000 do: [ :i | i isPrime ifTrue: [ gen yield: i ] ] ].
	timer := GenExperimentTimer new
		blockReps: 1;
		measureReps: 500.
	^ self generators collect: [ :generator |
		generator name -> (timer minFor: [ | gen |
			gen := generator on: primesBody.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]
]
