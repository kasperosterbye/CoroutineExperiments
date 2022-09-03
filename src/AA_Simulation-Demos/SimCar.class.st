Class {
	#name : #SimCar,
	#superclass : #SimSimulationObject,
	#category : #'AA_Simulation-Demos'
}

{ #category : #simulation }
SimCar >> tasks [

"Sample, without replacement, the direction through the intersection that the car will
travel"

| sample |

sample := SimSampleSpace data: #(left left right

straight straight straight straight straight).

(Simulation active) update: sample next.
]
