Class {
	#name : #SimHistogram,
	#superclass : #Object,
	#instVars : [
		'tallyArray',
		'lowerBound',
		'upperBound',
		'step',
		'minValue',
		'maxValue',
		'totalValues',
		'extraEntries'
	],
	#category : #'AA_Simulation statistics gathering'
}

{ #category : #'class initialization' }
SimHistogram class >> from: lowerNum to: upperNum by: step [
        ^self new newLower: lowerNum upper: upperNum by: step
]

{ #category : #accessing }
SimHistogram >> contains: aValue [
        ^lowerBound <= aValue and: [aValue < upperBound]
]

{ #category : #printing }
SimHistogram >> firstHeader: aStream [
        aStream cr; tab.
        aStream nextPutAll: 'Number of '.
        aStream tab.
        aStream nextPutAll: 'Minimum '.
        aStream tab.
        aStream nextPutAll: 'Maximum '.
        aStream tab.
        aStream nextPutAll: 'Average '.
        aStream cr; tab.
        aStream nextPutAll: 'Objects '.
        aStream tab.
        aStream nextPutAll: 'Value '.
        aStream tab.
        aStream nextPutAll: 'Value '.
        aStream tab.
        aStream nextPutAll: 'Value '.
]

{ #category : #private }
SimHistogram >> newLower: lowerNum upper: upperNum by: stepAmount [
        tallyArray := Array new: (upperNum - lowerNum // stepAmount).
        tallyArray atAllPut: 0.
        lowerBound := lowerNum.
        upperBound := upperNum.
        step := stepAmount.
        minValue := maxValue := nil.
        totalValues := 0.
        extraEntries := 0
]

{ #category : #printing }
SimHistogram >> printStatisticsOn: aStream [  
        | totalObjs pos |
        self firstHeader: aStream.
        aStream cr; tab.
        totalObjs := extraEntries.
        tallyArray do: [:each | totalObjs := totalObjs + each].
        totalObjs printOn: aStream.
        aStream tab.
        minValue printOn: aStream.
        aStream tab.
        maxValue printOn: aStream.
        aStream tab.
        (totalValues / totalObjs) asFloat printOn: aStream.
        aStream cr.
        self secondHeader: aStream.
        aStream cr.
        pos := lowerBound.
        tallyArray do:  
                [:entry |  
                pos printOn: aStream.
                aStream nextPut: $-.
                (pos := pos + step) printOn: aStream.
                aStream tab.
                entry printOn: aStream.
                aStream tab.
                (entry / totalObjs) asFloat printOn: aStream.
                aStream tab.
                aStream nextPut: $|.
                entry rounded timesRepeat: [aStream nextPut: $X].
                aStream cr]
]

{ #category : #printing }
SimHistogram >> secondHeader: aStream [
        aStream cr; tab.
        aStream nextPutAll: 'Number of '.
        aStream cr.
        aStream nextPutAll: 'Entry '.
        aStream tab.
        aStream nextPutAll: 'Objects '.
        aStream tab.
        aStream nextPutAll: 'Frequency '.
]

{ #category : #accessing }
SimHistogram >> store: aValue [  
        | index |
        minValue isNil
                ifTrue: [minValue := maxValue := aValue]
                ifFalse:  
                        [minValue := minValue min: aValue.
                        maxValue := maxValue max: aValue].
        totalValues := totalValues + aValue.
        (self contains: aValue)
                ifTrue:  
                        [index := (aValue - lowerBound // step) + 1.
                        tallyArray at: index put: (tallyArray at: index) + 1]
                ifFalse: [extraEntries := extraEntries + 1]
]
