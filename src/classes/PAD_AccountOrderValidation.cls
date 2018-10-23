public class PAD_AccountOrderValidation implements XAP_TRIG_TriggerEventHandlerIntf {
	DAO_OrderSelector orderSelector;
	XAP_UTIL_ListExtractor listExtractor;
	
	public PAD_AccountOrderValidation(DAO_OrderSelector orderSelector, XAP_UTIL_ListExtractor listExtractor) {
		this.orderSelector = orderSelector;
		this.listExtractor = listExtractor; 
	}

	public PAD_AccountOrderValidation() {
		this(DAO_OrderSelector.getInstance(), XAP_UTIL_ListExtractor.getInstance());
	} 

	private static String errorMessage 
		= 'Location cannot be set to Dead if there are Orders associated with the Location with Status <> Invoiced'; 

	public XAP_TRIG_TriggerEventHandlerIntf handle(XAP_TRIG_TriggerWrapper triggerWrapper) {
		Map<Id, Account> newDeadAccountByIdMap = new Map<Id, Account>((List<Account>)this.listExtractor
			.extractWhereChangedToValueFrom(
				triggerWrapper.newSObjectList, 
				triggerWrapper.oldSObjectByIdMap, 
				Account.Dead_Live__c,  
				'DEAD'
			)); 
			
		for (Id accountId : this.orderSelector.findNotInvoicedAccountIdSet(newDeadAccountByIdMap.keySet())) {
			newDeadAccountByIdMap.get(accountId).addError(errorMessage);
		}
		return this; 
	} 
}