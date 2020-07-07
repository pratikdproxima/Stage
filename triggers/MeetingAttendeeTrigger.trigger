trigger MeetingAttendeeTrigger on Meeting_Attendees__c (after insert,after Update) {
   // EventTriggerHandler handler = new EventTriggerHandler();
    MeetingAttendeeTriggerHandler handler = new MeetingAttendeeTriggerHandler();
    TriggerDispatcher.Run(handler);
}