Class {
	#name : #SimCarDelivery,
	#superclass : #SimSimulationObject,
	#category : #'AA_Simulation-Demos'
}

{ #category : #simulation }
SimCarDelivery >> tasks [

"Get access to the Car resource and 

produce 10, 11, or 12 cars."

self produce: ((SimSampleSpace 

data: #(10 11 12)) next) 

ofResource: 'Car'.

"Schedule a new delivery in 90 days"

(Simulation active) scheduleArrivalOf: self

at: (Simulation active) time + 90.
]
