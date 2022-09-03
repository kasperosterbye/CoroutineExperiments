Class {
	#name : #SimStatisticsWithSimulation,
	#superclass : #Simulation,
	#instVars : [
		'statistics'
	],
	#category : #'AA_Simulation statistics gathering'
}

{ #category : #'simulation scheduling' }
SimStatisticsWithSimulation >> enter: anObject [  
        statistics at: anObject put: (SimSimulationObjectRecord new entrance: currentTime)
]

{ #category : #'simulation scheduling' }
SimStatisticsWithSimulation >> exit: anObject [  
        (statistics at: anObject) exit: currentTime
]

{ #category : #initialization }
SimStatisticsWithSimulation >> initialize [
        super initialize.
        statistics := Dictionary new.
]

{ #category : #statistics }
SimStatisticsWithSimulation >> printStatisticsOn: aStream [  
        | stat |
        aStream cr.
        aStream nextPutAll: ' Object'.
        aStream tab.
        aStream nextPutAll: 'Entrance Time'.
        aStream tab.
        aStream nextPutAll: 'Duration'.
        aStream cr.
        stat := SortedCollection sortBlock: [:i :j | i value entrance <= j value entrance].
        statistics associationsDo: [:each | stat add: each].  
        stat do:  
                [:anAssociation |  
                aStream cr.
                anAssociation key printOn: aStream.
                aStream tab.
                anAssociation value printOn: aStream]
]
