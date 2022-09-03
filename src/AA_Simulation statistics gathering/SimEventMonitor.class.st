Class {
	#name : #SimEventMonitor,
	#superclass : #SimSimulationObject,
	#instVars : [
		'label'
	],
	#classVars : [
		'Counter',
		'DataFile'
	],
	#category : #'AA_Simulation statistics gathering'
}

{ #category : #'class initialization' }
SimEventMonitor class >> file: aFile [
        DataFile := aFile.
        Counter := 0
]

{ #category : #'task language' }
SimEventMonitor >> acquire: amount ofResource: resourceName [
        | aStaticResource |
        self timeStamp.
        DataFile nextPutAll: ' requests '.
        amount printOn: DataFile.
        DataFile nextPutAll: ' of ', resourceName.
        aStaticResource := super acquire: amount ofResource: resourceName.
        self timeStamp.
        DataFile nextPutAll: ' obtained '.
        amount printOn: DataFile.
        DataFile nextPutAll: ' of ', resourceName.
        ^aStaticResource
]

{ #category : #'task language' }
SimEventMonitor >> acquire: amount ofResource: resourceName withPriority: priorityNumber [
        | aStaticResource |
        self timeStamp.
        DataFile nextPutAll: ' requests '.
        amount printOn: DataFile.
        DataFile nextPutAll: ' at priority '.
        priorityNumber printOn: DataFile.
        DataFile nextPutAll: ' of ', resourceName.
        aStaticResource := super acquire: amount ofResource: resourceName withPriority: priorityNumber.
        self timeStamp.
        DataFile nextPutAll: ' obtained '.
        amount printOn: DataFile.
        DataFile nextPutAll: ' of ', resourceName.
        ^aStaticResource
]

{ #category : #'task language' }
SimEventMonitor >> acquireResource: resourceName [
        | anEvent |
        self timeStamp.
        DataFile nextPutAll: ' wants to serve for '.
        DataFile nextPutAll: resourceName.
        anEvent := super acquireResource: resourceName.
        self timeStamp.
        DataFile nextPutAll: ' can serve '.
        anEvent resource printOn: DataFile.
        ^anEvent
]

{ #category : #scheduling }
SimEventMonitor >> finishUp [
        super finishUp.
        self timeStamp.
        DataFile nextPutAll: ' exits '.
]

{ #category : #'task language' }
SimEventMonitor >> holdFor: aTimeDelay [
        self timeStamp.
        DataFile nextPutAll: ' holds for '.
        aTimeDelay printOn: DataFile.
        super holdFor: aTimeDelay
]

{ #category : #initialization }
SimEventMonitor >> initialize [
        super initialize.
        self setLabel
]

{ #category : #accessing }
SimEventMonitor >> label [
        ^label
]

{ #category : #printing }
SimEventMonitor >> printOn: aStream [
        self class name printOn: aStream.
        aStream space.
        aStream nextPutAll: self label
]

{ #category : #'task language' }
SimEventMonitor >> produce: amount ofResource: resourceName [
        self timeStamp.
        DataFile nextPutAll: ' produces '.
        amount printOn: DataFile.
        DataFile nextPutAll: ' of ', resourceName.
        super produce: amount ofResource: resourceName
]

{ #category : #'task language' }
SimEventMonitor >> produceResource: resourceName [
        self timeStamp.
        DataFile nextPutAll: ' wants to get service as '.
        DataFile nextPutAll: resourceName.
        super produceResource: resourceName
]

{ #category : #'task language' }
SimEventMonitor >> release: aStaticResource [
        self timeStamp.
        DataFile nextPutAll: ' releases '.
        aStaticResource amount printOn: DataFile.
        DataFile nextPutAll: ' of ', aStaticResource name.
        super release: aStaticResource
]

{ #category : #'task language' }
SimEventMonitor >> resume: anEvent [
        self timeStamp.
        DataFile nextPutAll: ' resumes '.
        anEvent resource printOn: DataFile.
        super resume: anEvent
]

{ #category : #accessing }
SimEventMonitor >> setLabel [
        Counter := Counter + 1.
        label := Counter printString.
]

{ #category : #scheduling }
SimEventMonitor >> startUp [
        self timeStamp.
        DataFile nextPutAll: ' enters '.
        super startUp
]

{ #category : #private }
SimEventMonitor >> timeStamp [
        DataFile cr.
        Simulation active time printOn: DataFile.
        DataFile tab.
        self printOn: DataFile
]
