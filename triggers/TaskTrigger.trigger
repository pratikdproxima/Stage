trigger TaskTrigger on Task (before insert,before update) {
   TaskTriggerHandler handler = new TaskTriggerHandler();
    TriggerDispatcher.Run(handler);
}