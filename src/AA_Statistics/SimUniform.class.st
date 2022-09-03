Class {
	#name : #SimUniform,
	#superclass : #SimContinuousProbability,
	#instVars : [
		'startNumber',
		'stopNumber'
	],
	#category : #'AA_Statistics'
}

{ #category : #'instance creation' }
SimUniform class >> from: begin to: end [  
        begin > end
                ifTrue: [self error: 'illegal interval']
                ifFalse: [^self new setStart: begin toEnd: end]
]

{ #category : #'probability functions' }
SimUniform >> density: x [  
        (x between: startNumber and: stopNumber)
                ifTrue: [^1.0 / (stopNumber - startNumber)]
                ifFalse: [^0]
]

{ #category : #private }
SimUniform >> inverseDistribution: x [
        "x is a random  number between 0 and 1"
        ^startNumber + (x * (stopNumber - startNumber))
]

{ #category : #accessing }
SimUniform >> mean [
        ^ (startNumber + stopNumber)/2
]

{ #category : #private }
SimUniform >> setStart: begin toEnd: end [
        startNumber := begin.
        stopNumber := end
]

{ #category : #accessing }
SimUniform >> variance [
        ^ (stopNumber - stopNumber) squared / 12
]
