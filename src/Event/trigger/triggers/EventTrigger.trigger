trigger EventTrigger on Event (after insert) {
    TriggerHandlerEvent.manage();
}