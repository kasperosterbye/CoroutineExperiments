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

	^ { 
		  GenCoSuspendGenerator.
		  GenCoSwapGenerator.
		  GenProcessSemaphoreGenerator.
		  GenProcessSuspendGenerator.
		  GenBufferingSuspendGenerator.
		  Generator }
]

{ #category : #performance }
GenPerformanceTests >> performMeasurementNumbers [
	| generatorBody timer |
	generatorBody := [ :gen | 
		1 to: 1000 do: [ :i | gen yield: i ] ].
	timer := GenExperimentTimer new
		blockReps: 5;
		measureReps: 300.
	^ ((self generators collect: [ :generator |
		generator name -> (timer minFor: [ | gen |
			gen := generator on: generatorBody.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]) sort: [ :a :b | a value < b value ]) asOrderedDictionary 
]

{ #category : #performance }
GenPerformanceTests >> performMeasurementPrimes [
	| generatorBody timer |
	generatorBody := [ :gen | 
		1000000 to: 1020000 do: [ :i | i isPrime ifTrue: [ gen yield: i ] ] ].
	timer := GenExperimentTimer new
		blockReps: 1;
		measureReps: 100.
	^ ((self generators collect: [ :generator |
		generator name -> (timer minFor: [ | gen |
			gen := generator on: generatorBody.
			[ gen atEnd ] whileFalse: [ gen next ]
			])]) sort: [ :a :b | a value < b value ]) asOrderedDictionary 
]

{ #category : #performance }
GenPerformanceTests >> performMeasurementSorting [
	| sorter task timer |
	sorter := GeneratorSort new.
	task := sorter testSize: 1000.
	timer := GenExperimentTimer new
		blockReps: 1;
		measureReps: 200.
	^ ((self generators collect: [ :generator |
			sorter := GeneratorSort new generatorClass: generator.
			generator name -> (timer minFor: [ sorter sort: task ])]) 
		sort: [ :a :b | a value < b value ]) asOrderedDictionary 
]

{ #category : #reporting }
GenPerformanceTests >> report [
	"report a number of csv lines on the form: testname, subject, time"
	 ^ ((self performMeasurementNumbers associations collect: [ :assoc |
		'numbers;' , assoc key,';', assoc value asString
		 ]),
	(self performMeasurementPrimes  associations collect: [ :assoc |
		'primes;' , assoc key,';', assoc value asString
		 ]),
	(self performMeasurementSorting associations collect: [ :assoc |
		'sorting;' , assoc key,';', assoc value asString
		 ])) joinUsing: String cr
	
]
