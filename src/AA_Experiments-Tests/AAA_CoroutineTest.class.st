"
An AAA_CoroutineTest is a test class for testing the behavior of AAA_Coroutine
"
Class {
	#name : #'AAA_CoroutineTest',
	#superclass : #TestCase,
	#category : #'AA_Experiments-Tests'
}

{ #category : #testing }
AAA_CoroutineTest >> testAttachValueReturn [
	| co foo |
	co := AAA_Coroutine on: [ :cor | foo := cor suspend. foo := cor suspend].
	co attach. "run to first suspend"
	co attach: 17. "perform assignment, and run til next suspend"
	self assert: foo equals: 17.
	co attach: 19. "perform assignment and finish"
	self assert: foo equals: 19.
	self assert: co isTerminated
]

{ #category : #testing }
AAA_CoroutineTest >> testCanAttach [
	| co foo |
	co := AAA_Coroutine on: [ :cor | foo := 17 ].
	self assert: foo equals: nil.
	co attach.
	self assert: foo equals: 17.
	self assert: co isTerminated 
]

{ #category : #testing }
AAA_CoroutineTest >> testCanAttachMultipleTimes [
	| co foo |
	co := AAA_Coroutine on: [ :cor | foo := 17. cor suspend. foo := 19. cor suspend. foo := 21 ].
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
AAA_CoroutineTest >> testCanInitialize [
	| co |
	co := AAA_Coroutine on: [ :cor |  ].
	self assert: co class equals: AAA_Coroutine.
	self deny: co isTerminated 
]

{ #category : #testing }
AAA_CoroutineTest >> testSuspendValueReturn [
	| co foo |
	co := AAA_Coroutine on: [ :cor | cor suspend: 17. cor suspend: 19 ].
	foo := co attach.
	self assert: foo equals: 17.
	foo := co attach.
	self assert: foo equals: 19.
	self deny: co isTerminated. 
	co attach.
	self assert: co isTerminated 
]

{ #category : #tests }
AAA_CoroutineTest >> testTerminate [
	| co |
	co := AAA_Coroutine on: [ :cor | cor suspend ].
	co terminate.
	self assert: co isTerminated.
	self 
		should: [ co attach ]
		raise: AAA_CoroutineTerminated
]

{ #category : #tests }
AAA_CoroutineTest >> testTerminateWithUnwind [
	| co foo|
	foo := 17.
	co := AAA_Coroutine on: [ :cor | [cor suspend] ensure: [ foo := 19 ] ].
	co attach.
	co terminate.
	self assert: co isTerminated.
	self assert: foo equals: 19
]

{ #category : #testing }
AAA_CoroutineTest >> testTerminationError [
	| co |
	co := AAA_Coroutine on: [ :cor | ].
	"Test that empty coroutine can be attached"
	co attach.
	"Test that attaching a terminated coroutine gives error"
	self assert: co isTerminated.
	self 
		should: [ co attach ]
	 	raise:  AAA_CoroutineTerminated 
]

{ #category : #testing }
AAA_CoroutineTest >> testTerminationOnError [
	| co |
	co := AAA_Coroutine on: [ :cor | cor error: 'Uuups' ].
	"Test that empty coroutine can be attached"
	self 
		should: [co attach]
	 	raise:  Error 
]
