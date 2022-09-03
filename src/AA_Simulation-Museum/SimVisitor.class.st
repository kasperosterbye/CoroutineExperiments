Class {
	#name : #SimVisitor,
	#superclass : #SimSimulationObject,
	#instVars : [
		'entryTime'
	],
	#category : #'AA_Simulation-Museum'
}

{ #category : #access }
SimVisitor >> entryTime [
   ^entryTime.
]

{ #category : #'class initialization' }
SimVisitor >> initialize [
        super initialize.
        entryTime := Simulation active time.
]

{ #category : #access }
SimVisitor >> tasks [
        self holdFor:
                (SimNormal mean: 20 deviation: 5) next.
]
