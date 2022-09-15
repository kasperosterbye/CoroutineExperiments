Class {
	#name : #GenAbstractGenerator,
	#superclass : #Stream,
	#category : #'GeneratorExperiments-Generators'
}

{ #category : #'instance creation' }
GenAbstractGenerator class >> on: block [
	^ self basicNew on: block
]

{ #category : #accessing }
GenAbstractGenerator >> atEnd [
	self subclassResponsibility
]

{ #category : #accessing }
GenAbstractGenerator >> contents [
	"Answer the contents of this generator. Do not call this method on infinite generators."

	| stream |
	stream := (Array new: 10) writeStream.
	[ self atEnd ]
		whileFalse: [ stream nextPut: self next ].
	^ stream contents
]

{ #category : #accessing }
GenAbstractGenerator >> next [
	"Answer the next object accessible by the receiver."

	self subclassResponsibility
]

{ #category : #accessing }
GenAbstractGenerator >> nextPut: anObject [ 
	"Insert the argument, anObject, as the next object accessible by the 
	receiver. Answer anObject."
	
	self yield: anObject
]
