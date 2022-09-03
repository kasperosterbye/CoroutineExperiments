"
How long before a success occurs or how many events occur in a certain time interval?
"
Class {
	#name : #SimNormal,
	#superclass : #SimContinuousProbability,
	#instVars : [
		'mu',
		'sigma'
	],
	#category : #'AA_Statistics'
}

{ #category : #'instance creation' }
SimNormal class >> mean: a deviation: b [
        b > 0.0
        ifTrue: [^self new setMean: a standardDeviation: b]
        ifFalse: [self error: 'standard deviation must be greater than 0.0']
]

{ #category : #'probability functions' }
SimNormal >> density: x [

        | twoPi t |
        twoPi := 2 * 3.1415926536.
        t := x - mu/sigma.
        ^(-0.5 * t squared) exp / (sigma * twoPi sqrt)
]

{ #category : #accessing }
SimNormal >> mean [
        ^mu
]

{ #category : #'random sampling' }
SimNormal >> next [
        | v1 v2 s rand u |
        rand := SimUniform from: -1.0 to: 1.0.
        [v1 := rand next.
         v2 := rand next.
         s := v1 squared + v2 squared.
         s >= 1] whileTrue.
        u := (-2.0 * s ln /s) sqrt.
        ^mu + (sigma * v1 *u)
]

{ #category : #private }
SimNormal >> setMean: m standardDeviation: s [
        mu := m.
        sigma := s
]

{ #category : #accessing }
SimNormal >> variance [
        ^sigma squared
]
