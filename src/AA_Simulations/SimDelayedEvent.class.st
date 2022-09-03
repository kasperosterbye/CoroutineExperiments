Class {
	#name : #SimDelayedEvent,
	#superclass : #Object,
	#instVars : [
		'resumptionSemaphore',
		'resumptionCondition'
	],
	#category : #'AA_Simulations'
}

{ #category : #'instance creation' }
SimDelayedEvent class >> new [
	^super new initialize
]

{ #category : #'instance creation' }
SimDelayedEvent class >> onCondition: anObject [
	^super new setCondition: anObject
]

{ #category : #comparing }
SimDelayedEvent >> <= aDelayedEvent [
	"Answer whether the receiver should be sequenced before the argument."
	
	resumptionCondition isNil
		ifTrue: [^true]
		ifFalse: [^resumptionCondition <= aDelayedEvent condition]
]

{ #category : #accessing }
SimDelayedEvent >> condition [
	"Answer a condition under which the event should be sequenced."

	^resumptionCondition
]

{ #category : #accessing }
SimDelayedEvent >> condition: anObject [
	"The argument, anObject, is the condition under which the event should be sequenced."

	resumptionCondition := anObject
]

{ #category : #private }
SimDelayedEvent >> initialize [
	resumptionSemaphore := Semaphore new
]

{ #category : #scheduling }
SimDelayedEvent >> pause [
	"Suspend the current active process, that is, the current event that is running."

	Simulation active stopProcess.
	resumptionSemaphore wait
]

{ #category : #scheduling }
SimDelayedEvent >> resume [
	"Resume the suspended process."
	Simulation active startProcess.
	resumptionSemaphore signal.
	^resumptionCondition
]

{ #category : #private }
SimDelayedEvent >> setCondition: anObject [
	self initialize.
	resumptionCondition := anObject
]
