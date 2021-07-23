global class VisitRecommendation {
    
    global class DataContainer {
        @InvocableVariable
        public string targetDate; 
        
        @InvocableVariable
        public List<Recommendation> recommendations;
    }
    
    
    @InvocableMethod(label='Last Visit earlier than 30 days' description='Returns the list of stores which are not visited for more than 30 days.')
    public static List<List<Recommendation>> getVisits(List<DataContainer> inputData) {
        List<List<Recommendation>> recos = new List<List<Recommendation>>();
        for(DataContainer dc : inputData){
            date targetDate = Date.valueOf(dc.targetDate);
            List<Recommendation> output = new List<Recommendation>();
            for(Recommendation rec : dc.recommendations){
                String storeId = rec.ExternalId;
                List<Visit> lastVisits = [SELECT ActualVisitStartTime FROM Visit 
                               WHERE PlaceId = :storeId AND ActualVisitStartTime != NULL
                               ORDER BY ActualVisitStartTime DESC];
                if (lastVisits.size() > 0){
                    datetime dT = lastVisits[0].ActualVisitStartTime;
                    Date prevDate = Date.newinstance(dT.year(), dT.month(), dT.day());
                    if (prevDate.daysBetween(targetDate) > 30) {
                        output.add(rec);
                    }
                }
                else {
                       output.add(rec);                
                }
            }
            recos.add(output);
        }
        return recos;
    }
}