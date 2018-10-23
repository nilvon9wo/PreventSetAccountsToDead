public virtual class DAO_OrderSelector {
	private static DAO_OrderSelector INSTANCE;
	protected DAO_OrderSelector() {
	}
	
	public static DAO_OrderSelector getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new DAO_OrderSelector();
		}
		return INSTANCE;
	}

	private static final String INVOICED = 'Invoiced'; 

	// This returns a map so we can have a friendlier API.
	// Also, if you want to create true/proper/atomic unit tests,
	// returning AggregateResults presents a problem since we can't construct these. 
	public virtual Map<Id, Integer> countNotInvoicedForAccounts(Set<Id> accountIdSet) {
		List<AggregateResult> aggregateResultList = [
			SELECT AccountId, COUNT(Id) invoicedCount
			FROM Order
			WHERE Status != :INVOICED
				AND AccountId IN :accountIdSet
			GROUP BY AccountId
		];
		
		Map<Id, Integer> invoiceCountByAccountIdMap = new Map<Id, Integer>();
		for (AggregateResult aggregateResult : aggregateResultList) {
			invoiceCountByAccountIdMap.put(
				(Id) aggregateResult.get('AccountId'), 
				(Integer) aggregateResult.get('invoicedCount')
			);
		}
		return invoiceCountByAccountIdMap;
	}
}