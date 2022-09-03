Class {
	#name : #SimResource,
	#superclass : #Object,
	#instVars : [
		'pending',
		'resourceName'
	],
	#category : #'AA_Simulations'
}

{ #category : #'instance creation' }
SimResource class >> named: resourceName [
	^self new setName: resourceName
]

{ #category : #accessing }
SimResource >> acquire [
	^self
]

{ #category : #accessing }
SimResource >> addRequest: aDelayedEvent [
	pending add: aDelayedEvent.
	self provideResources.
	aDelayedEvent pause.
]

{ #category : #accessing }
SimResource >> name [
	^resourceName
]

{ #category : #private }
SimResource >> provideResources [
	^self
]

{ #category : #private }
SimResource >> setName: aString [
	resourceName := aString.
	pending := SortedCollection new
]
