Class {
	#name : #SimContinuousProbability,
	#superclass : #SimProbabilityDistribution,
	#category : #'AA_Statistics'
}

{ #category : #'probability functions' }
SimContinuousProbability >> distribution: aCollection [
        "This is a slow and dirty trapezoidal integration to determine the area under the probability function curve y=density (x) for x in the specified collection.  The method assumes that the collection contains numerically-ordered elements."

        | t aStream x1 x2 y1 y2 |
        t := 0.0.
        aStream := ReadStream on: aCollection.
        x2 := aStream next.
        y2 := self density: x2.
        [x1 := x2.  x2 := aStream next]
                whileTrue:  
                        [y1 := y2.
                         y2 := self density: x2.
                         t := t + ((x2-x1)*(y2+y1))].
        ^t*0.5
]
