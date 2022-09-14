"
I perform a number of different performance tests on the five generator implementations
"
Class {
	#name : #GenPerformanceTests,
	#superclass : #Object,
	#category : #'GeneratorExperiments-Performance'
}

{ #category : #'as yet unclassified' }
GenPerformanceTests >> performMeasurementNumbers [
	| candidates timer |
	candidates := { GenGenerator. GenSimpleGenerator. ProcessSemaphoreGenerator. ProcessSuspendGenerator. Generator}.
	timer := GenExperimentTimer new
		blockReps: 100;
		measureReps: 1000.
	^ candidates collect: [ :generator |
		Smalltalk garbageCollect.
		generator name -> (timer forkingMinFor: [ | gen |
			gen := self yieldNumbers: generator.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]
]

{ #category : #'as yet unclassified' }
GenPerformanceTests >> performMeasurementPrimes [
	| candidates timer |
	candidates := { GenGenerator. GenSimpleGenerator. ProcessSemaphoreGenerator. ProcessSuspendGenerator. Generator}.
	timer := GenExperimentTimer new
		blockReps: 1;
		measureReps: 500.
	^ candidates collect: [ :generator |
		generator name -> (timer minFor: [ | gen |
			gen := self yieldPrimes: generator.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]
]

{ #category : #'as yet unclassified' }
GenPerformanceTests >> yieldNumbers: generatorClass [
	^ generatorClass on: [ :gen | 
		(1 to: 10) do: [ :i | gen yield: i ] ].
]

{ #category : #'as yet unclassified' }
GenPerformanceTests >> yieldPrimes: generatorClass [
	^ generatorClass on: [ :gen | 
		(1000000 to: 1100000) do: [ :i | i isPrime ifTrue: [ gen yield: i ] ] ].
]
