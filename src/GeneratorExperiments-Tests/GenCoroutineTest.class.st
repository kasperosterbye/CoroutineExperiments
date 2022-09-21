"
An AAA_CoroutineTest is a test class for testing the behavior of AAA_Coroutine
"
Class {
	#name : #GenCoroutineTest,
	#superclass : #TestCase,
	#category : #'GeneratorExperiments-Tests-Coroutines'
}

{ #category : #'as yet unclassified' }
GenCoroutineTest >> coroutineClass [
	^ GenSuspendCoroutine 
]

{ #category : #testing }
GenCoroutineTest >> testAttachValueReturn [
	| co foo |
	co := self coroutineClass on: [ :cor | foo := cor suspend. foo := cor suspend].
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
	co := self coroutineClass on: [ :cor | foo := 17 ].
	self assert: foo equals: nil.
	co attach.
	self assert: foo equals: 17.
	self assert: co isTerminated 
]

{ #category : #testing }
GenCoroutineTest >> testCanAttachMultipleTimes [
	| co foo |
	co := self coroutineClass on: [ :cor | foo := 17. cor suspend. foo := 19. cor suspend. foo := 21 ].
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
	co := self coroutineClass on: [ :cor |  ].
	self assert: co class equals: self coroutineClass.
	self deny: co isTerminated 
]

{ #category : #tests }
GenCoroutineTest >> testNested [
	| c1 c2 foo |
	c1 := self coroutineClass on: [ :cor | cor suspend: 17. cor suspend: 19 ].
	c2 := self coroutineClass on: [ :cor | cor suspend: c1 attach. cor suspend: c1 attach. c1 attach ].
	foo := c2 attach.
	self assert: foo equals: 17.
	foo := c2 attach.
	self assert: foo equals: 19.
	self deny: c2 isTerminated. 
	c2 attach.
	self assert: c1 isTerminated.
	self assert: c2 isTerminated  
]

{ #category : #tests }
GenCoroutineTest >> testNestedNoDoubleTermination [
	| c1 c2 foo |
	c1 := self coroutineClass on: [ :cor | ].
	c2 := self coroutineClass on: [ :cor | c1 attach. cor suspend: 10].
	foo := c2 attach.
	self deny: c2 isTerminated. 
	self assert: foo equals: 10.
]

{ #category : #testing }
GenCoroutineTest >> testSuspendValueReturn [
	| co foo |
	co := self coroutineClass on: [ :cor | cor suspend: 17. cor suspend: 19 ].
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
	co := self coroutineClass on: [ :cor | cor suspend. ].
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
	co := self coroutineClass on: [ :cor | [cor suspend] ensure: [ foo := 19 ] ].
	co attach.
	co terminate.
	self assert: co isTerminated.
	self assert: foo equals: 19
]

{ #category : #testing }
GenCoroutineTest >> testTerminationError [
	| co |
	co := self coroutineClass on: [ :cor | ].
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
	co := self coroutineClass on: [ :cor | cor error: 'Uuups' ].
	"Test that empty coroutine can be attached"
	self 
		should: [co attach]
	 	raise:  Error 
]
