Class {
	#name : #SimResourceProvider,
	#superclass : #SimResource,
	#instVars : [
		'amountAvailable'
	],
	#category : #'AA_Simulations'
}

{ #category : #'instance creation' }
SimResourceProvider class >> named: aResourceName [
	^self new setName: aResourceName with: 0
]

{ #category : #'instance creation' }
SimResourceProvider class >> named: aResourceName with: amount [
	^self new setName: aResourceName with: amount
]

{ #category : #'task language' }
SimResourceProvider >> acquire: amountNeeded withPriority: priorityNumber [ 
	| waiting |
	waiting := SimWaitingSimulationObject
					for: amountNeeded 
					of: self
					withPriority: priorityNumber.
	self addRequest: waiting.
	^waiting
]

{ #category : #accessing }
SimResourceProvider >> amountAvailable [
	^amountAvailable
]

{ #category : #'task language' }
SimResourceProvider >> produce: amount [
	amountAvailable := amountAvailable + amount.
	self provideResources
]

{ #category : #private }
SimResourceProvider >> provideResources [
	| waiting |
	[pending isEmpty not and: [pending first amount <= amountAvailable]]
		whileTrue: 
			[waiting := pending removeFirst.
			amountAvailable := amountAvailable - waiting amount.
			waiting resume]
]

{ #category : #private }
SimResourceProvider >> setName: aResourceName with: amount [
	super setName: aResourceName.
	amountAvailable := amount
]
