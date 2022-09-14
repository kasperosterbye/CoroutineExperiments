"
An AAA_CoroutineTest is a test class for testing the behavior of AAA_Coroutine
"
Class {
	#name : #GenCoroutineTest,
	#superclass : #TestCase,
	#category : #'GeneratorExperiments-Tests'
}

{ #category : #testing }
GenCoroutineTest >> testAttachValueReturn [
	| co foo |
	co := GenCoroutine on: [ :cor | foo := cor suspend. foo := cor suspend].
	co attach. "run to first suspend"
	co attach: 17. "perform assignment, and run til next suspend"
	self assert: foo equals: 17.
	co attach: 19. "perform assignment and finish"
	self assert: foo equals: 19.
	self assert: co isTerminated
]

{ #category : #testing }
GenCoroutineTest >> testCanAttach [
	| co foo |
	co := GenCoroutine on: [ :cor | foo := 17 ].
	self assert: foo equals: nil.
	co attach.
	self assert: foo equals: 17.
	self assert: co isTerminated 
]

{ #category : #testing }
GenCoroutineTest >> testCanAttachMultipleTimes [
	| co foo |
	co := GenCoroutine on: [ :cor | foo := 17. cor suspend. foo := 19. cor suspend. foo := 21 ].
	self assert: foo equals: nil.
	self deny: co isTerminated. 
	co attach.
	self assert: foo equals: 17.
	self deny: co isTerminated. 
	co attach.
	self assert: foo equals: 19.
	self deny: co isTerminated. 
	co attach.
	self assert: foo equals: 21.
	self assert: co isTerminated 
]

{ #category : #testing }
GenCoroutineTest >> testCanInitialize [
	| co |
	co := GenCoroutine on: [ :cor |  ].
	self assert: co class equals: GenCoroutine.
	self deny: co isTerminated 
]

{ #category : #testing }
GenCoroutineTest >> testSuspendValueReturn [
	| co foo |
	co := GenCoroutine on: [ :cor | cor suspend: 17. cor suspend: 19 ].
	foo := co attach.
	self assert: foo equals: 17.
	foo := co attach.
	self assert: foo equals: 19.
	self deny: co isTerminated. 
	co attach.
	self assert: co isTerminated 
]

{ #category : #tests }
GenCoroutineTest >> testTerminate [
	| co |
	co := GenCoroutine on: [ :cor | cor suspend ].
	co terminate.
	self assert: co isTerminated.
	self 
		should: [ co attach ]
		raise: GenCoroutineTerminated
]

{ #category : #tests }
GenCoroutineTest >> testTerminateWithUnwind [
	| co foo|
	foo := 17.
	co := GenCoroutine on: [ :cor | [cor suspend] ensure: [ foo := 19 ] ].
	co attach.
	co terminate.
	self assert: co isTerminated.
	self assert: foo equals: 19
]

{ #category : #testing }
GenCoroutineTest >> testTerminationError [
	| co |
	co := GenCoroutine on: [ :cor | ].
	"Test that empty coroutine can be attached"
	co attach.
	"Test that attaching a terminated coroutine gives error"
	self assert: co isTerminated.
	self 
		should: [ co attach ]
	 	raise:  GenCoroutineTerminated 
]

{ #category : #testing }
GenCoroutineTest >> testTerminationOnError [
	| co |
	co := GenCoroutine on: [ :cor | cor error: 'Uuups' ].
	"Test that empty coroutine can be attached"
	self 
		should: [co attach]
	 	raise:  Error 
]
