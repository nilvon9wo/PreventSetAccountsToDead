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
	public virtual Set<Id> findNotInvoicedAccountIdSet(Set<Id> accountIdSet) {
		List<AggregateResult> aggregateResultList = [
			SELECT AccountId
			FROM Order
			WHERE Status != :INVOICED 
				AND AccountId IN :accountIdSet
			GROUP BY AccountId
		];
		
		Set<Id> uninvoicedAccountIdSet = new Set<Id>();
		for (AggregateResult aggregateResult : aggregateResultList) {
			uninvoicedAccountIdSet.add((Id) aggregateResult.get('AccountId'));
		}
		return uninvoicedAccountIdSet;
	}
}