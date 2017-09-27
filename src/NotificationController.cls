public class NotificationController {
//To get and set the sessionId to subscribe via cometD
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
    
    public static void publishNotifications(List<String> messages) {
        List<Notification__e> notifications = new List<Notification__e>();
        for (String message: messages) {
            notifications.add(new Notification__e(Message__c = message));
        }

        //Publish the Platform Event by using EventBus utility class
        List<Database.SaveResult> results = EventBus.publish(notifications);
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                for (Database.Error error : result.getErrors()) {
                    System.debug('Error returned: ' +
                                 error.getStatusCode() +' - '+
                                 error.getMessage());
                }
            }
        }
    }    
}
