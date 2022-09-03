Class {
	#name : #SimResourceCoordinator,
	#superclass : #SimResource,
	#instVars : [
		'whoIsWaiting'
	],
	#category : #'AA_Simulations'
}

{ #category : #'task language' }
SimResourceCoordinator >> acquire [
	|waiting|
	self customersWaiting ifTrue: [^self giveService].
	"get here if there is no customer waiting for the server."
	waiting := SimWaitingSimulationObject for: 1 withPriority: 0.
	whoIsWaiting := #server.
	self addRequest: waiting.
	^waiting resource
]

{ #category : #accessing }
SimResourceCoordinator >> customersWaiting [
	^whoIsWaiting == #customer
]

{ #category : #private }
SimResourceCoordinator >> getServiceFor: aCustomerRequest [

	| aServerRequest |
	aServerRequest := pending removeFirst.
	pending isEmpty ifTrue: [whoIsWaiting := #none].
	aServerRequest resource: aCustomerRequest.
	aServerRequest resume.
	aCustomerRequest pause
]

{ #category : #private }
SimResourceCoordinator >> giveService [
	|aCustomerRequest|
	aCustomerRequest:= pending removeFirst.
	pending isEmpty ifTrue: [whoIsWaiting := #none].
	^aCustomerRequest
]

{ #category : #'task language' }
SimResourceCoordinator >> producedBy: aCustomer [
	|waiting|
	waiting := SimWaitingSimulationObject for: 1
					of: aCustomer
					withPriority: 0.
	self serversWaiting ifTrue: [^self getServiceFor: waiting].
	whoIsWaiting := #customer.
	self addRequest: waiting
]

{ #category : #accessing }
SimResourceCoordinator >> queueLength [
	^pending size
]

{ #category : #accessing }
SimResourceCoordinator >> serversWaiting [
	^whoIsWaiting == #server
]

{ #category : #private }
SimResourceCoordinator >> setName: aString [
	super setName: aString.
	whoIsWaiting := #none
]
