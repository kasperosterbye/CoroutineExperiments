Class {
	#name : #SimWaitingSimulationObject,
	#superclass : #SimDelayedEvent,
	#instVars : [
		'amount',
		'resource'
	],
	#category : #'AA_Simulations'
}

{ #category : #'instance creation' }
SimWaitingSimulationObject class >> for: amount of: aResource withPriority: aNumber [
	^(self onCondition: aNumber) setAmount: amount resource: aResource
]

{ #category : #'instance creation' }
SimWaitingSimulationObject class >> for: amount withPriority: aNumber [
	^(self onCondition: aNumber) setAmount: amount resource: nil
]

{ #category : #accessing }
SimWaitingSimulationObject >> amount [
	^amount
]

{ #category : #'task language' }
SimWaitingSimulationObject >> consume: aNumber [
	amount := (amount - aNumber) max: 0
]

{ #category : #accessing }
SimWaitingSimulationObject >> name [
	^resource name
]

{ #category : #'task language' }
SimWaitingSimulationObject >> release [
	resource produce: amount.
	amount := 0
]

{ #category : #'task language' }
SimWaitingSimulationObject >> release: anAmount [
	resource produce: anAmount.
	amount := amount - anAmount
]

{ #category : #accessing }
SimWaitingSimulationObject >> resource [
	^resource
]

{ #category : #accessing }
SimWaitingSimulationObject >> resource: aResource [
	resource := aResource
]

{ #category : #private }
SimWaitingSimulationObject >> setAmount: aNumber resource: aResource [
	amount := aNumber.
	resource := aResource
]
