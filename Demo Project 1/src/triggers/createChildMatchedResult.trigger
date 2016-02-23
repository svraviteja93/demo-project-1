trigger createChildMatchedResult on Enquiry_Name__c (after insert , after update ) {


 Matched_Result__c[] existingResultList = [select Id from Matched_Result__c];
 
 for(Matched_Result__c existingResult : existingResultList ){
        try{
        delete existingResult;
        }catch (system.Dmlexception e) {
            system.debug (e);
            
        }
    }


 // Version 3.1 
 //ravi

 List<Matched_Result__c> matchedResults = new List<Matched_Result__c>();
 
         for (Enquiry_Name__c newEnquiry: Trigger.New) {
         
             Flat__c[] matchedFlat = [select Id, Name__c from Flat__c  where Rent__c = :newEnquiry.Rental_Price__c AND Furnishing__c = :newEnquiry.Furnishing__c AND Flat_Types__c = :newEnquiry.Flat_Types__c  ];
         
                 for(Flat__c flat : matchedFlat){
      
                     Matched_Result__c results = new Matched_Result__c();
                     results.Name_of_Enquiry__c = newEnquiry.Enquiry_Name__c;
                     results.Flat__c = flat.Id;
                 	
                    results.Name_of_Apartment__c = flat.Name__c;
                    
                     results.Enquiry__c = newEnquiry.Id;
                     matchedResults.add(results);
             
                 }
             
         
         }
         
    
         try{
             insert matchedResults;
         }catch(system.Dmlexception e){
              system.debug (e);
         }
    
   
 }