trigger AccountTrigger on Account (before update) {
    (new TRIG_AccountTriggerHandler()).invoke();
}