Class {
	#name : #SimNothingAtAll,
	#superclass : #Simulation,
	#category : #'AA_Simulation-Demos'
}

{ #category : #demos }
SimNothingAtAll class >> aDoNothingDemo [
	<script>
        | aSimulation aFile |
        aFile := 'demo.events3' asFileReference writeStream.
        SimDoNothing file: aFile.
        aSimulation := self new startUp.
        [aSimulation time < 25] whileTrue: [aSimulation proceed].
        aFile close
]

{ #category : #initialization }
SimNothingAtAll >> defineArrivalSchedule [
        self scheduleArrivalOf: SimDoNothing
                accordingTo: (SimUniform from:1 to:5).
]
