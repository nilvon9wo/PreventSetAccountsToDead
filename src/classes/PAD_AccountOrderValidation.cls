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
		List<Account> newAccountList = (List<Account>) triggerWrapper.newSObjectList;
		List<Account> newDeadAccountList = this.listExtractor
			.extractWhereChangedToValueFrom(newAccountList, triggerWrapper.oldSObjectByIdMap, Account.Dead_Live__c, 'DEAD');
			
		Map<Id, Account> newDeadAccountByIdMap = new Map<Id, Account>(newDeadAccountList); 
		Map<Id, Integer> invoicedCountByAccountIdMap = this.orderSelector.countInvoicedForAccounts(newDeadAccountByIdMap.keySet());
		for (Id accountId : invoicedCountByAccountIdMap.keySet()) {
			Integer invoicedCount = invoicedCountByAccountIdMap.get(accountId);
			if (invoicedCount > 0) {
				newDeadAccountByIdMap.get(accountId).addError(errorMessage);
			}
		}
		return this;
	} 
}