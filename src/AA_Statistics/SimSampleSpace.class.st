Class {
	#name : #SimSampleSpace,
	#superclass : #SimDiscreteProbability,
	#instVars : [
		'data'
	],
	#category : #'AA_Statistics'
}

{ #category : #'instance creation' }
SimSampleSpace class >> data: aCollection [
         
        ^self new setData: aCollection
]

{ #category : #Examples }
SimSampleSpace class >> heights [

        | heights |
        heights := SampleSpace data: #(60 60 60 62 62 64 64 64 64 66 66 66 68 68 68 68 68 70 70 70).
         
        "what is the probability of randomly selecting a student with height 64?"
        heights density: 64.

        "what is the probability of randomly selecting a student whose height is between 60 and 64?"
        heights distribution: (60 to: 64 by: 2)
]

{ #category : #'probability functions' }
SimSampleSpace >> density: x [
        "x must be in the sample space;  the probability must sum over all occurrences of x in the sample space."

        (data includes: x)
                ifTrue: [^(data occurrencesOf: x) / data size]
                ifFalse: [^0]
]

{ #category : #private }
SimSampleSpace >> inverseDistribution: x [
         
        ^data at: (x*data size) truncated + 1
]

{ #category : #private }
SimSampleSpace >> setData: aCollection [
         
        data := aCollection
]
