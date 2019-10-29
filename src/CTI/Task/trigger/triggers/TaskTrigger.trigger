trigger TaskTrigger on Task (after insert) {
    TriggerHandlerTask.manage();
}