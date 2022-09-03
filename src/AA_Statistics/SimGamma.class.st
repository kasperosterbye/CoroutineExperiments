Class {
	#name : #SimGamma,
	#superclass : #SimExponential,
	#instVars : [
		'N'
	],
	#category : #'AA_Statistics'
}

{ #category : #'instance creation' }
SimGamma class >> events: k mean: p [

        |  events |
        events := k truncated.
        events > 0
                ifTrue: [^(self parameter: events/p) setEvents: events]
                ifFalse: [self error: 'the number of events must be greater than 0']
]

{ #category : #'probability functions' }
SimGamma >> density: x [
        | t |
        x > 0.0
                ifTrue: [t := mu * x.
                        ^(mu raisedTo: N) / (self gamma: N) *(x raisedTo: N-1) * t negated exp]
                ifFalse: [^0.0]
]

{ #category : #private }
SimGamma >> gamma: n [
        | t |
        t := n - 1.0.
        ^self computeSample: t outOf: t
]

{ #category : #accessing }
SimGamma >> mean [
        ^super mean*N
]

{ #category : #private }
SimGamma >> setEvents: events [
        N := events
]

{ #category : #accessing }
SimGamma >> variance [
        ^super variance*N
]
